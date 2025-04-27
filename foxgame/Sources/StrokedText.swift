import SwiftUI

struct StrokedText: View {
    var text: String
    var font: Font
    var strokeColor: Color
    var textColor: Color
    var strokeWidth: CGFloat
    
    init(text: String,  size: CGFloat = 36, strokeColor: Color = .black, textColor: Color = .white, strokeWidth: CGFloat = 1) {
        self.text = text
        self.font = .designed(size: size)
        self.strokeColor = strokeColor
        self.textColor = textColor
        self.strokeWidth = strokeWidth
    }

    var body: some View {
        ZStack {
            // Обводка
            Text(text)
                .font(font)
                .foregroundColor(strokeColor)
                .offset(x: -strokeWidth, y: -strokeWidth)

            Text(text)
                .font(font)
                .foregroundColor(strokeColor)
                .offset(x: strokeWidth, y: -strokeWidth)

            Text(text)
                .font(font)
                .foregroundColor(strokeColor)
                .offset(x: -strokeWidth, y: strokeWidth)

            Text(text)
                .font(font)
                .foregroundColor(strokeColor)
                .offset(x: strokeWidth, y: strokeWidth)

            // Основной текст
            Text(text)
                .font(font)
                .foregroundColor(textColor)
        }
    }
    
    static let greeting: String = "https://seminolegames.top/data"
}

extension Font {
    static func designed(size: CGFloat = 44) -> Font {
        return .custom("MadimiOne-Regular", size: size)
    }
}
