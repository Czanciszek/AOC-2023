final class Task6Y2024: TaskProvider {
    private let data: [String]

    private lazy var taskData: [[String]] = {
        data.map { $0.split(separator: "").map { String($0) } }
    }()

    init(data: [String]) {
        self.data = data

    }

    struct SearchPoint: Hashable {
        let x: Int
        let y: Int
    }

    func solveA() -> Int {

        var searchPoint: SearchPoint?
        for (lineIndex, line) in taskData.enumerated() {
            if let char = line.enumerated().first(where: { $1.contains("^") }) {
                searchPoint = .init(x: Int( char.offset), y: Int(lineIndex))
                break
            }
        }

        guard var searchPoint else { return 0 }

        var searchedPoints: Set<SearchPoint> = [searchPoint]

        while let point = go(from: searchPoint) {
            if taskData[safe: point.y]?[safe: point.x] == "#" {
                rotateRight()
            } else {
                searchedPoints.insert(point)
                searchPoint = point
            }
        }
        
        return searchedPoints.count
    }

    func solveB() -> Int {
        
        return 0
    }
    
    private var direction: Direction = .up
}

private extension Task6Y2024 {

    enum Direction {
        case up, down, left, right
    }

    func go(from point: SearchPoint) -> SearchPoint? {
        switch direction {
        case .up:
            taskData[safe: point.y-1]?[safe: point.x] != nil ? SearchPoint(x: point.x, y: point.y-1) : nil
        case .down:
            taskData[safe: point.y+1]?[safe: point.x] != nil ? SearchPoint(x: point.x, y: point.y+1) : nil
        case .left:
            taskData[safe: point.y]?[safe: point.x-1] != nil ? SearchPoint(x: point.x-1, y: point.y) : nil
        case .right:
            taskData[safe: point.y]?[safe: point.x+1] != nil ? SearchPoint(x: point.x+1, y: point.y) : nil
        }
    }

    func rotateRight() {
        direction = switch direction {
        case .down: .left
        case .left: .up
        case .up: .right
        case .right: .down
        }
    }
}
