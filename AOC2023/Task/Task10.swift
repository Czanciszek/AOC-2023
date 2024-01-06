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
        var row = data.firstIndex(where: { $0.contains(.start) })!
        var column = data[row].firstIndex(where: { $0 == .start })!

        var currentWay: Way = .N
        var enclosedLoop: [LoopPoint] = [
            LoopPoint(row: row, column: column),
        ]

        repeat {
            currentWay = makeStep(from: currentWay, to: data[row][column])
            (row, column) = currentWay.nextIndex(row: row, column: column)
            enclosedLoop.append(LoopPoint(row: row, column: column))
        } while data[row][column] != .start

        return enclosedLoop.count / 2
    }

    func solveB() -> Int {
        // TODO: Create solution
        return -1
    }
}

private extension Task10 {
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
        case (_, .start): .N
        case (.N, .NS), (.E, .NW), (.W, .NE): .N
        case (.S, .NS), (.E, .SW), (.W, .SE): .S
        case (.N, .SE), (.S, .NE), (.E, .EW): .E
        case (.N, .SW), (.S, .NW), (.W, .EW): .W
        default: .N
        }
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
