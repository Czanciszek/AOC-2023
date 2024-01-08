//
//  Task10.swift
//  AOC2023
//
//  Created by Franciszek Czana on 30/12/2023.
//

import Foundation

final class Task10: TaskProvider {
    private let data: [[Direction]]

    init(data: [String]) {
        self.data = data
            .compactMap { String($0).compactMap { $0.asDirection } }
    }

    func solveA() -> Int {
        findEnclosedLoop().count / 2
    }

    func solveB() -> Int {
        let enclosedLoop = findEnclosedLoop()

        var result = 0

        for row in 0 ..< data.count {
            var inPolygon = false
            var crossingCandidate: Direction?

            for column in 0 ..< data[0].count {
                let point = LoopPoint(row: row, column: column)

                if enclosedLoop.contains(point) {
                    var pointDirection = data[row][column]
                    if pointDirection == .start {
                        pointDirection = obtainStartDirection()
                    }

                    if pointDirection == .NS {
                        inPolygon.toggle()
                    } else if pointDirection == .NE || pointDirection == .SE {
                        crossingCandidate = pointDirection
                    } else if pointDirection == .SW {
                        if crossingCandidate == .NE {
                            inPolygon.toggle()
                        }
                        crossingCandidate = nil
                    } else if pointDirection == .NW || pointDirection == .start {
                        if crossingCandidate == .SE {
                            inPolygon.toggle()
                        }
                        crossingCandidate = nil
                    }
                } else if inPolygon {
                    result += 1
                }
            }
        }

        return result
    }
}

private extension Task10 {
    func findEnclosedLoop() -> [LoopPoint] {
        guard var row = data.firstIndex(where: { $0.contains(.start) }),
              var column = data[row].firstIndex(where: { $0 == .start })
        else {
            return []
        }

        var currentWay: Way = .N
        var enclosedLoop: [LoopPoint] = [
            LoopPoint(row: row, column: column),
        ]

        repeat {
            currentWay = makeStep(from: currentWay, to: data[row][column])
            (row, column) = currentWay.nextIndex(row: row, column: column)
            enclosedLoop.append(LoopPoint(row: row, column: column))
        } while data[row][column] != .start

        return enclosedLoop
    }

    struct LoopPoint: Equatable {
        let row: Int
        let column: Int
    }

    enum Direction {
        case NS, NE, EW, SE, SW, NW, start, none
    }

    enum Way {
        case N, E, S, W

        func nextIndex(row: Int, column: Int) -> (Int, Int) {
            switch self {
            case .N: (row - 1, column)
            case .S: (row + 1, column)
            case .E: (row, column + 1)
            case .W: (row, column - 1)
            }
        }
    }

    private func makeStep(from way: Way, to next: Direction) -> Way {
        switch (way, next) {
        case (_, .start): makeStep(from: way, to: obtainStartDirection())
        case (.N, .NS), (.E, .NW), (.W, .NE): .N
        case (.S, .NS), (.E, .SW), (.W, .SE): .S
        case (.N, .SE), (.S, .NE), (.E, .EW): .E
        case (.N, .SW), (.S, .NW), (.W, .EW): .W
        default: .N
        }
    }

    private func obtainStartDirection() -> Direction {
        guard let row = data.firstIndex(where: { $0.contains(.start) }),
              let column = data[row].firstIndex(where: { $0 == .start })
        else {
            return .NW
        }

        var ways: [Way] = []

        if row > 0 {
            let up = data[row - 1][column]
            if up == .NS || up == .SE || up == .SW {
                ways.append(.N)
            }
        }

        if row < data.count - 1 {
            let down = data[row + 1][column]
            if down == .NS || down == .NE || down == .NW {
                ways.append(.S)
            }
        }

        if column > 0 {
            let left = data[row][column - 1]
            if left == .EW || left == .NE || left == .SE {
                ways.append(.W)
            }
        }

        if column < data[0].count - 1 {
            let right = data[row][column + 1]
            if right == .EW || right == .NW || right == .SW {
                ways.append(.E)
            }
        }

        guard ways.count == 2 else {
            return .NW
        }

        switch (ways[0], ways[1]) {
        case (.N, _):
            switch (ways[0], ways[1]) {
            case (_, .E): return .NE
            case (_, .W): return .NW
            case (_, .S): return .NS
            default: break
            }
        case (.S, _):
            switch (ways[0], ways[1]) {
            case (_, .N): return .NS
            case (_, .E): return .SE
            case (_, .W): return .SW
            default: break
            }
        case (.E, _):
            switch (ways[0], ways[1]) {
            case (_, .N): return .NE
            case (_, .S): return .SE
            case (_, .W): return .EW
            default: break
            }
        case (.W, _):
            switch (ways[0], ways[1]) {
            case (_, .N): return .NW
            case (_, .S): return .SW
            case (_, .E): return .EW
            default: break
            }
        }

        return .NW
    }
}

private extension Character {
    var asDirection: Task10.Direction {
        switch self {
        case "|": .NS
        case "-": .EW
        case "L": .NE
        case "F": .SE
        case "7": .SW
        case "J": .NW
        case "S": .start
        default: .none
        }
    }
}
