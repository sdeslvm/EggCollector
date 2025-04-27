import SpriteKit

// Структура для узла в алгоритме A*
class Node {
    let position: CGPoint
    let g: CGFloat // Стоимость пути от старта до узла
    let h: CGFloat // Эвристика (манхэттенское расстояние до цели)
    let f: CGFloat // Общая стоимость (g + h)
    let parent: Node? // Ссылка на родительский узел
    init(position: CGPoint, g: CGFloat, h: CGFloat, parent: Node? = nil) {
        self.position = position
        self.g = g
        self.h = h
        self.f = g + h
        self.parent = parent
    }
}

class GameScene: SKScene {
    var chicken: SKSpriteNode!
    var eggs: [SKSpriteNode] = []
    var walls: [SKSpriteNode] = []
    var fox: SKSpriteNode!
    weak var joystick: Joystick?

    var lastPathUpdateTime: TimeInterval = 0 // Время последнего обновления пути
    let pathUpdateInterval: TimeInterval = 1 // Интервал обновления пути (1 секунда)
    // Сетка для поиска пути
    let gridCellSize: CGFloat = 20 // Размер ячейки сетки
    var gridWidth: Int = 0
    var gridHeight: Int = 0
    var grid: [[Bool]] = [] // true - проходимо, false - стена
    var path: [CGPoint] = [] // Путь, по которому движется лиса
    let cellSize = CGSize(width: 100, height: 100)
    let wallWidth: CGFloat = 10
    
   
    override func didMove(to view: SKView) {
        print("Размер сцены: \(size), frame: \(frame.size)")
//        backgroundColor = .green
//        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.isDynamic = false
        
        // Создаем спрайт с изображением backgroundField
        let defaults = UserDefaults.standard
        
            let background = SKSpriteNode(imageNamed: "field\(defaults.integer(forKey: "field"))1")
            
            // Устанавливаем позицию в центре сцены
            background.position = CGPoint(x: frame.midX, y: frame.midY)
            
            // Масштабируем, чтобы соответствовать размеру сцены (опционально)
            background.size = self.size
            
            // Устанавливаем zPosition, чтобы фон был позади других объектов
            background.zPosition = -1
            
            // Добавляем спрайт на сцену
            addChild(background)
            
            physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

        // Инициализация сетки
        initializeGrid()

        // Создаём внешние стены
        createOuterWalls()

        // Создаём внутренние стены
        createInnerWalls()

        // Создаём курицу
        spawnChicken()

        // Создаём лису
//        fox = SKSpriteNode(color: .brown, size: CGSize(width: 30, height: 30))
//        let defaults = UserDefaults.standard
        print((defaults.integer(forKey: "player")))
        fox = SKSpriteNode(imageNamed: "fox\(defaults.integer(forKey: "player"))1")
        fox.size = CGSize(width: 30, height: 30)
        fox.position = CGPoint(x: size.width * 3 / 4, y: size.height * 3 / 4)
        fox.physicsBody = SKPhysicsBody(rectangleOf: fox.size)
        fox.physicsBody?.isDynamic = true
        fox.physicsBody?.categoryBitMask = 3
        fox.physicsBody?.collisionBitMask = 1
        fox.physicsBody?.contactTestBitMask = 1
        fox.physicsBody?.affectedByGravity = false // Отключаем гравитацию
        addChild(fox)

        // Создаём яйца
        createEggs()
    }

    // Инициализация сетки для поиска пути
    func initializeGrid() {
        gridWidth = Int(size.width / gridCellSize)
        gridHeight = Int(size.height / gridCellSize)
        grid = Array(repeating: Array(repeating: true, count: gridWidth), count: gridHeight)

        // Отмечаем ячейки, занятые стенами
        for wall in walls {
            let minX = Int(wall.frame.minX / gridCellSize)
            let maxX = Int(wall.frame.maxX / gridCellSize)
            let minY = Int(wall.frame.minY / gridCellSize)
            let maxY = Int(wall.frame.maxY / gridCellSize)
            let startY = max(0, minY)
            let endY = min(gridHeight - 1, maxY)
            if startY <= endY {
                for y in startY...endY {
                    let startX = max(0, minX)
                    let endX = min(gridWidth - 1, maxX)
                    if startX <= endX {
                        for x in startX...endX {
                            grid[y][x] = false
                        }
                    }
                }
            }
        }
    }

    // Преобразование координат в индексы сетки
    func gridPosition(_ point: CGPoint) -> (Int, Int) {
        let x = Int(point.x / gridCellSize)
        let y = Int(point.y / gridCellSize)
        return (max(0, min(x, gridWidth - 1)), max(0, min(y, gridHeight - 1)))
    }

    // Преобразование индексов сетки в координаты
    func pointFromGrid(_ x: Int, _ y: Int) -> CGPoint {
        return CGPoint(x: CGFloat(x) * gridCellSize + gridCellSize / 2,
                       y: CGFloat(y) * gridCellSize + gridCellSize / 2)
    }

    // Алгоритм A* для поиска пути
    func findPath(from start: CGPoint, to goal: CGPoint) -> [CGPoint] {
        let (startX, startY) = gridPosition(start)
        let (goalX, goalY) = gridPosition(goal)
        var openList: [Node] = []
        var closedList: Set<String> = []
        let startNode = Node(position: pointFromGrid(startX, startY), g: 0, h: manhattanDistance(from: (startX, startY), to: (goalX, goalY)))
        openList.append(startNode)

        while !openList.isEmpty {
            // Находим узел с наименьшей стоимостью f
            openList.sort { $0.f < $1.f }
            let currentNode = openList.removeFirst()
            let (currentX, currentY) = gridPosition(currentNode.position)
            let key = "\(currentX),\(currentY)"
            if closedList.contains(key) { continue }
            closedList.insert(key)

            // Если достигли цели, восстанавливаем путь
            if currentX == goalX && currentY == goalY {
                var path: [CGPoint] = []
                var node: Node? = currentNode
                while let current = node {
                    path.append(current.position)
                    node = current.parent
                }
                return path.reversed()
            }

            // Проверяем соседние ячейки (вверх, вниз, влево, вправо)
            let directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]
            for (dx, dy) in directions {
                let newX = currentX + dx
                let newY = currentY + dy
                if newX < 0 || newX >= gridWidth || newY < 0 || newY >= gridHeight { continue }
                if !grid[newY][newX] { continue }
                if closedList.contains("\(newX),\(newY)") { continue }
                let newPosition = pointFromGrid(newX, newY)
                let g = currentNode.g + gridCellSize
                let h = manhattanDistance(from: (newX, newY), to: (goalX, goalY))
                let newNode = Node(position: newPosition, g: g, h: h, parent: currentNode)
                openList.append(newNode)
            }
        }
        return [] // Путь не найден
    }

    // Манхэттенское расстояние
    func manhattanDistance(from: (Int, Int), to: (Int, Int)) -> CGFloat {
        return CGFloat(abs(from.0 - to.0) + abs(from.1 - to.1)) * gridCellSize
    }

    func spawnChicken() {
        let maxCols = Int(size.width / cellSize.width)
        let maxRows = Int(size.height / cellSize.height)
        guard maxCols > 0, maxRows > 0 else {
            print("Размер сцены слишком мал!")
            return
        }
//        chicken = SKSpriteNode(color: .yellow, size: CGSize(width: 30, height: 30))
        chicken = SKSpriteNode(imageNamed: "chicken")
        chicken.size = CGSize(width: 30, height: 30)
        chicken.zPosition = 10
        var spawnPosition: CGPoint?
        var attempts = 100
        while spawnPosition == nil && attempts > 0 {
            let col = Int.random(in: 0..<maxCols)
            let row = Int.random(in: 0..<maxRows)
            let potentialPosition = CGPoint(x: CGFloat(col) * cellSize.width + cellSize.width / 2,
                                           y: CGFloat(row) * cellSize.height + cellSize.height / 2)
            let isBlocked = walls.contains { $0.frame.contains(potentialPosition) }
            if !isBlocked {
                spawnPosition = potentialPosition
            }
            attempts -= 1
        }
        guard let finalPosition = spawnPosition else {
            print("Не удалось найти свободное место для курицы 😢")
            return
        }
        chicken.position = finalPosition
        chicken.physicsBody = SKPhysicsBody(rectangleOf: chicken.size)
        chicken.physicsBody?.isDynamic = true
        chicken.physicsBody?.categoryBitMask = 2
        chicken.physicsBody?.collisionBitMask = 1
        chicken.physicsBody?.contactTestBitMask = 1
        chicken.physicsBody?.affectedByGravity = false
        addChild(chicken)
    }

    func createOuterWalls() {
        // Верхняя стенка
        let topWall = SKSpriteNode(color: .brown, size: CGSize(width: size.width, height: wallWidth))
        topWall.position = CGPoint(x: size.width / 2, y: size.height - wallWidth / 2)
        setupWallPhysics(topWall)
        addChild(topWall)
        walls.append(topWall)

        // Нижняя стенка
        let bottomWall = SKSpriteNode(color: .brown, size: CGSize(width: size.width, height: wallWidth))
        bottomWall.position = CGPoint(x: size.width / 2, y: wallWidth / 2)
        setupWallPhysics(bottomWall)
        addChild(bottomWall)
        walls.append(bottomWall)

        // Левая стенка
        let leftWall = SKSpriteNode(color: .brown, size: CGSize(width: wallWidth, height: size.height))
        leftWall.position = CGPoint(x: wallWidth / 2, y: size.height / 2)
        setupWallPhysics(leftWall)
        addChild(leftWall)
        walls.append(leftWall)

        // Правая стенка
        let rightWall = SKSpriteNode(color: .brown, size: CGSize(width: wallWidth, height: size.height))
        rightWall.position = CGPoint(x: size.width - wallWidth / 2, y: size.height / 2)
        setupWallPhysics(rightWall)
        addChild(rightWall)
        walls.append(rightWall)
    }

    func createInnerWalls() {
        let rows = 2 // 2 ряда по вертикали
        let cols = 3 // 3 столбца по горизонтали

        // Размеры ячеек
        let cellWidth = size.width / CGFloat(cols)
        let cellHeight = size.height / CGFloat(rows)

        // Минимальный размер прохода (1.7 * высота курицы)
        let chickenHeight: CGFloat = 30 // Высота курицы из spawnChicken()
        let minGapSize: CGFloat = 1.7 * chickenHeight // 51

        // Вертикальные стены: три сегмента с проходами сверху и снизу
        for col in 1..<cols {
            let wallX = CGFloat(col) * cellWidth

            // Суммарная высота двух проходов
            let totalGapsHeight = 2 * minGapSize // 102
            let remainingHeight = max(size.height - totalGapsHeight, 0) // Оставшаяся высота для сегментов

            // Верхний и нижний сегменты (по 20% от оставшейся высоты)
            let topBottomSegmentHeight = remainingHeight * 0.2

            // Средний сегмент (60% от оставшейся высоты)
            let middleSegmentHeight = remainingHeight * 0.6

            // Верхний сегмент
            let topSegment = SKSpriteNode(color: .brown, size: CGSize(width: wallWidth, height: topBottomSegmentHeight))
            topSegment.position = CGPoint(x: wallX, y: size.height - topBottomSegmentHeight / 2)
            setupWallPhysics(topSegment)
            addChild(topSegment)
            walls.append(topSegment)

            // Средний сегмент
            let middleSegment = SKSpriteNode(color: .brown, size: CGSize(width: wallWidth, height: middleSegmentHeight))
            middleSegment.position = CGPoint(x: wallX, y: (size.height - topBottomSegmentHeight - minGapSize) - middleSegmentHeight / 2)
            setupWallPhysics(middleSegment)
            addChild(middleSegment)
            walls.append(middleSegment)

            // Нижний сегмент
            let bottomSegment = SKSpriteNode(color: .brown, size: CGSize(width: wallWidth, height: topBottomSegmentHeight))
            bottomSegment.position = CGPoint(x: wallX, y: topBottomSegmentHeight / 2)
            setupWallPhysics(bottomSegment)
            addChild(bottomSegment)
            walls.append(bottomSegment)
        }

        // Горизонтальная стена: три сегмента с проходами, увеличенными в 3 раза
        let gapWidth = minGapSize * 3 // 153 (в 3 раза больше minGapSize)
        let totalGapsWidth = 2 * gapWidth // 306
        let remainingWidth = max(size.width - totalGapsWidth, 0) // Оставшаяся ширина для сегментов
        let segmentWidth = remainingWidth / 3 // Ширина каждого сегмента
        let wallY = cellHeight // Позиция горизонтальной стены

        // Левый сегмент
        let leftSegment = SKSpriteNode(color: .brown, size: CGSize(width: segmentWidth, height: wallWidth))
        leftSegment.position = CGPoint(x: segmentWidth / 2, y: wallY)
        setupWallPhysics(leftSegment)
        addChild(leftSegment)
        walls.append(leftSegment)

        // Средний сегмент
        let middleSegment = SKSpriteNode(color: .brown, size: CGSize(width: segmentWidth, height: wallWidth))
        middleSegment.position = CGPoint(x: segmentWidth + gapWidth + segmentWidth / 2, y: wallY)
        setupWallPhysics(middleSegment)
        addChild(middleSegment)
        walls.append(middleSegment)

        // Правый сегмент
        let rightSegment = SKSpriteNode(color: .brown, size: CGSize(width: segmentWidth, height: wallWidth))
        rightSegment.position = CGPoint(x: size.width - (segmentWidth / 2), y: wallY)
        setupWallPhysics(rightSegment)
        addChild(rightSegment)
        walls.append(rightSegment)

        // Обновляем сетку после создания стен
        initializeGrid()
    }

    func setupWallPhysics(_ wall: SKSpriteNode) {
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.categoryBitMask = 1
        wall.physicsBody?.collisionBitMask = 2 | 3
        wall.physicsBody?.contactTestBitMask = 2 | 3
        wall.physicsBody?.affectedByGravity = false
        wall.name = "wall"
    }

//    func createEggs() {
//        let rows = Int(size.height / cellSize.height)
//        let cols = Int(size.width / cellSize.width)
//        for row in 0..<rows {
//            for col in 0..<cols {
//                let cellRect = CGRect(
//                    x: CGFloat(col) * cellSize.width,
//                    y: CGFloat(row) * cellSize.height,
//                    width: cellSize.width,
//                    height: cellSize.height
//                )
//                let numEggs = Int.random(in: 1...2)
//                for _ in 0..<numEggs {
////                    let egg = SKSpriteNode(color: .white, size: CGSize(width: 20, height: 20))
//                    let egg = SKSpriteNode(imageNamed: "eggWhite")
//                    egg.size = CGSize(width: 20, height: 20)
//                    egg.position = CGPoint(
//                        x: CGFloat.random(in: cellRect.minX + 20...cellRect.maxX - 20),
//                        y: CGFloat.random(in: cellRect.minY + 20...cellRect.maxY - 20)
//                    )
////                    let border = SKShapeNode(rectOf: egg.size)
////                    border.strokeColor = .black
////                    border.lineWidth = 2
////                    egg.addChild(border)
//                    addChild(egg)
//                    eggs.append(egg)
//                }
//            }
//        }
//    }
    
    func createEggs() {
        let rows = Int(size.height / cellSize.height)
        let cols = Int(size.width / cellSize.width)

        for row in 0..<rows {
            for col in 0..<cols {
                let cellRect = CGRect(
                    x: CGFloat(col) * cellSize.width,
                    y: CGFloat(row) * cellSize.height,
                    width: cellSize.width,
                    height: cellSize.height
                )
                let numEggs = Int.random(in: 1...2)
                for _ in 0..<numEggs {
                    // Случайный выбор типа яйца
                    let eggTypes = ["eggWhite", "eggBlue", "eggPink"]
                    let randomEggType = eggTypes.randomElement()!

                    let egg = SKSpriteNode(imageNamed: randomEggType)
                    egg.size = CGSize(width: 20, height: 20)
                    egg.position = CGPoint(
                        x: CGFloat.random(in: cellRect.minX + 20...cellRect.maxX - 20),
                        y: CGFloat.random(in: cellRect.minY + 20...cellRect.maxY - 20)
                    )
                    egg.name = randomEggType // Устанавливаем имя для идентификации
                    addChild(egg)
                    eggs.append(egg)
                    let defaults = UserDefaults.standard
                    switch randomEggType {
                                        case "eggWhite":
                        let count = defaults.integer(forKey: "whiteEggCount") + 1
                        defaults.set(count, forKey: "whiteEggCount")
                                        case "eggBlue":
                        let count = defaults.integer(forKey: "blueEggCount") + 1
                        defaults.set(count, forKey: "blueEggCount")
                                        case "eggPink":
                        let count = defaults.integer(forKey: "pinkEggCount") + 1
                        defaults.set(count, forKey: "pinkEggCount")
                                        default:
                                            break
                                        }
                }
            }
        }
    }
    
    enum EggType: String {
        case white = "eggWhite"
        case blue = "eggBlue"
        case pink = "eggPink"
    }

    override func update(_ currentTime: TimeInterval) {
        guard let joystick = joystick, let chicken = chicken else { return }
        
        // Движение курицы
        let speed: CGFloat = 2.0
        let dx = joystick.x * speed
        let dy = joystick.y * speed
        chicken.physicsBody?.velocity = CGVector(dx: dx * 50, dy: dy * 50)
        
        // Проверка сбора яиц
//        for (index, egg) in eggs.enumerated().reversed() {
//            if chicken.frame.intersects(egg.frame) {
//                egg.removeFromParent()
//                eggs.remove(at: index)
//            }
//        }
        
        // Проверка сбора яиц
                for (index, egg) in eggs.enumerated().reversed() {
                    if chicken.frame.intersects(egg.frame) {
                        if let eggName = egg.name, let eggType = EggType(rawValue: eggName) {
                            // Обновляем соответствующий счетчик в UserDefaults
                            let defaults = UserDefaults.standard
                            switch eggType {
                            case .white:
                                let count = defaults.integer(forKey: "whiteegg") + 1
                                defaults.set(count, forKey: "whiteegg")
                            case .blue:
                                let count = defaults.integer(forKey: "blueegg") + 1
                                defaults.set(count, forKey: "blueegg")
                            case .pink:
                                let count = defaults.integer(forKey: "pinkegg") + 1
                                defaults.set(count, forKey: "pinkegg")
                            }
                        }
                        egg.removeFromParent()
                        eggs.remove(at: index)
                    }
                }
        
        // Обновление пути для лисы
        if currentTime - lastPathUpdateTime >= pathUpdateInterval {
            path = findPath(from: fox.position, to: chicken.position)
            lastPathUpdateTime = currentTime // Обновляем время последнего расчета пути
        }
        
        // Движение лисы по пути
        if !path.isEmpty {
            let nextPoint = path.first!
            let foxDX = nextPoint.x - fox.position.x
            let foxDY = nextPoint.y - fox.position.y
            let distance = sqrt(foxDX * foxDX + foxDY * foxDY)
            
            if distance < 5 {
                path.removeFirst() // Достигли точки, переходим к следующей
            } else {
                let foxSpeed: CGFloat = 1.5
                fox.position = CGPoint(
                    x: fox.position.x + foxDX / distance * foxSpeed,
                    y: fox.position.y + foxDY / distance * foxSpeed
                )
            }
        }
        
        // Проверка условий победы/проигрыша
        if chicken.frame.intersects(fox.frame) {
            let defaults = UserDefaults.standard
            let count = defaults.integer(forKey: "lifeBalance") - 1
            defaults.set(count, forKey: "lifeBalance")
            print("Проигрыш!")
        } else if eggs.isEmpty {
            print("Победа!")
        }
    }
}
