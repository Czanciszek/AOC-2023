final class Task4Y2024: TaskProvider {
    private let data: [String]

    private lazy var taskData: [[String]] = {
        data.map { $0.split(separator: "").map { String($0) } }
    }()
    
    private var startPoints: [SearchPoint] = []
    private var usedPoints: [SearchPoint] = []

    init(data: [String]) {
        self.data = data
    }

    func solveA() -> Int {
        taskData.enumerated().forEach { lineIndex, line in
            line.enumerated().forEach { charIndex, character in
                if character == "X" {
                    startPoints.append((x: charIndex, y: lineIndex))
                }
            }
        }

        return startPoints.reduce(0) {
            $0 + xmasCrosses(in: $1)
        }
    }

    func solveB() -> Int {
        startPoints = []
        taskData.enumerated().forEach { lineIndex, line in
            line.enumerated().forEach { charIndex, character in
                if character == "A" {
                    startPoints.append((x: charIndex, y: lineIndex))
                }
            }
        }

        return startPoints.filter { isXMASShape(in: $0) }.count
    }
}

private extension Task4Y2024 {
    
    typealias SearchPoint = (x: Int, y: Int)
    
    func mapData() -> [[String]] {
        data.map { $0.split(separator: "").map { String($0) } }
    }
    
    func xmasCrosses(in point: SearchPoint) -> Int {
        let shapes = [
            [
                taskData[safe: point.y]?[safe: point.x-1],
                taskData[safe: point.y]?[safe: point.x-2],
                taskData[safe: point.y]?[safe: point.x-3],
            ],
            [
                taskData[safe: point.y]?[safe: point.x+1],
                taskData[safe: point.y]?[safe: point.x+2],
                taskData[safe: point.y]?[safe: point.x+3],
            ],
            [
                taskData[safe: point.y-1]?[safe: point.x],
                taskData[safe: point.y-2]?[safe: point.x],
                taskData[safe: point.y-3]?[safe: point.x],
            ],
            [
                taskData[safe: point.y+1]?[safe: point.x],
                taskData[safe: point.y+2]?[safe: point.x],
                taskData[safe: point.y+3]?[safe: point.x],
            ],
            [
                taskData[safe: point.y-1]?[safe: point.x-1],
                taskData[safe: point.y-2]?[safe: point.x-2],
                taskData[safe: point.y-3]?[safe: point.x-3],
            ],
            [
                taskData[safe: point.y-1]?[safe: point.x+1],
                taskData[safe: point.y-2]?[safe: point.x+2],
                taskData[safe: point.y-3]?[safe: point.x+3],
            ],
            [
                taskData[safe: point.y+1]?[safe: point.x-1],
                taskData[safe: point.y+2]?[safe: point.x-2],
                taskData[safe: point.y+3]?[safe: point.x-3],
            ],
            [
                taskData[safe: point.y+1]?[safe: point.x+1],
                taskData[safe: point.y+2]?[safe: point.x+2],
                taskData[safe: point.y+3]?[safe: point.x+3],
            ]
        ]

        return shapes
            .filter { $0[0] == "M" && $0[1] == "A" && $0[2] == "S" }
            .count
    }
    
    func isXMASShape(in point: SearchPoint) -> Bool {

        let nwCorner = taskData[safe: point.y-1]?[safe: point.x-1]
        let neCorner = taskData[safe: point.y-1]?[safe: point.x+1]
        let swCorner = taskData[safe: point.y+1]?[safe: point.x-1]
        let seCorner = taskData[safe: point.y+1]?[safe: point.x+1]

        if (nwCorner == "M" && seCorner == "S") || (nwCorner == "S" && seCorner == "M") {
            return (swCorner == "M" && neCorner == "S") || (swCorner == "S" && neCorner == "M")
        }

        return false
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
