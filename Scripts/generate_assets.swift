import Foundation

// MARK: - Настройки

let xcassetsPath = "\(FileManager.default.currentDirectoryPath)/foxGame/Sources/Assets.xcassets"
let outputFilePath = "\(FileManager.default.currentDirectoryPath)/foxGame/Sources/Generated/Assets.swift"

struct Asset {
    let pathComponents: [String]
    let name: String
}

// MARK: - Поиск ассетов (imageset) с учётом вложенных папок

func findImageAssets(in xcassetsPath: String) -> [Asset] {
    var result: [Asset] = []
    let fm = FileManager.default

    guard let subpaths = try? fm.subpathsOfDirectory(atPath: xcassetsPath) else {
        print("❌ Cannot read xcassets at path: \(xcassetsPath)")
        return []
    }

    for path in subpaths {
        print("📂 Found: \(path)")
        guard path.hasSuffix(".imageset") else { continue }

        let components = path.components(separatedBy: "/").map {
            $0.replacingOccurrences(of: ".imageset", with: "")
        }

        guard let name = components.last else { continue }
        result.append(Asset(pathComponents: components, name: name))
    }

    return result
}

// MARK: - Генерация Swift кода

func generateSwiftCode(from assets: [Asset]) -> String {
    var tree: [String: Any] = [:]

    func insert(into dict: inout [String: Any], path: [String], value: String) {
        guard let first = path.first else { return }

        if path.count == 1 {
            dict[first] = value
            return
        }

        if dict[first] == nil {
            dict[first] = [String: Any]()
        }

        var subdict = dict[first] as! [String: Any]
        insert(into: &subdict, path: Array(path.dropFirst()), value: value)
        dict[first] = subdict
    }

    for asset in assets {
        insert(into: &tree, path: asset.pathComponents, value: asset.name)
    }

    func generateEnum(name: String?, content: [String: Any], level: Int = 1) -> String {
        var result = ""
        let indent = String(repeating: "    ", count: level)

        if let name = name {
            result += "\(indent)enum \(name) {\n"
        }

        for (key, value) in content.sorted(by: { $0.key < $1.key }) {
            let safeKey = key
                .replacingOccurrences(of: "-", with: "_")
                .replacingOccurrences(of: " ", with: "_")

            if let imageName = value as? String {
                result += """
                \(indent)    static let \(safeKey): Image = {
                \(indent)        Image("\(imageName)").resizable()
                \(indent)    }()
                
                """
            } else if let subContent = value as? [String: Any] {
                result += generateEnum(name: safeKey, content: subContent, level: level + 1)
            }
        }

        if name != nil {
            result += "\(indent)}\n"
        }

        return result
    }

    let header = """
    import SwiftUI

    enum Assets {
    """

    let footer = "}\n"
    let enums = generateEnum(name: nil, content: tree)

    return header + enums + footer
}

// MARK: - Main

func main() {
    print("🔍 Scanning assets in: \(xcassetsPath)")
    let assets = findImageAssets(in: xcassetsPath)

    for asset in assets {
        print("🧩 Asset: \(asset.name), components: \(asset.pathComponents)")
    }

    print("📦 Found \(assets.count) image assets")

    let code = generateSwiftCode(from: assets)

    do {
        try FileManager.default.createDirectory(
            atPath: (outputFilePath as NSString).deletingLastPathComponent,
            withIntermediateDirectories: true
        )
        try code.write(toFile: outputFilePath, atomically: true, encoding: .utf8)
        print("✅ Generated \(outputFilePath)")
    } catch {
        print("❌ Error writing Assets.swift: \(error)")
        exit(1)
    }
}

main()
