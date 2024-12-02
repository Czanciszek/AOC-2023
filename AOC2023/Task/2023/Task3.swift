
//  Task3.swift
//  AOC2023
//
//  Created by Franciszek Czana on 11/12/2023.
//

import Foundation

final class Task3: TaskProvider {
    private let data: [[EngineChar]]

    init(data: [String]) {
        self.data = data
            .compactMap { $0.compactMap { c in EngineChar(char: c) } }
    }

    func solveA() -> Int {
        data.enumerated().reduce(0) {
            $0 + processLine(lineIndex: $1.offset, line: $1.element)
        }
    }

    func solveB() -> Int {
        data.enumerated().reduce(0) {
            $0 + searchLine(lineIndex: $1.offset, line: $1.element)
        }
    }
}

private extension Task3 {
    func processLine(lineIndex: Int, line: [EngineChar]) -> Int {
        var result = 0

        var start = -1
        var end = -1

        for (cIndex, char) in line.enumerated() {
            if char.isDigit {
                if start == -1 {
                    start = cIndex
                }
                end = cIndex

                if cIndex < line.count - 1 {
                    continue
                }
            }

            guard start != -1, end != -1 else {
                continue
            }

            // Obtain number
            let numberStr = Array(start ... end)
                .map { line[$0].value }
                .reduce("") { $0 + $1 }
            let number = Int(numberStr) ?? 0

            // Obtain corners
            let minX = max(start - 1, 0)
            let maxX = min(end + 1, line.count - 1)

            var points: [EngineChar] = [line[minX], line[maxX]]
            points.append(contentsOf: data[max(lineIndex - 1, 0)][minX ... maxX])
            points.append(contentsOf: data[min(lineIndex + 1, data.count - 1)][minX ... maxX])

            if points.contains(where: \.adjacentsToSymbol) {
                result += number
            }

            start = -1
            end = -1
        }

        return result
    }

    func searchLine(lineIndex: Int, line: [EngineChar]) -> Int {
        line.enumerated().reduce(0) {
            $0 + findConnectedGears(lineIndex: lineIndex, charIndex: $1.offset)
        }
    }

    private func findConnectedGears(lineIndex: Int, charIndex: Int) -> Int {
        guard data[lineIndex][charIndex] == .gear else { return 0 }
        let numbers = lookAround(row: lineIndex, position: charIndex)
        return numbers.count == 2 ? numbers.reduce(1) { $0 * $1 } : 0
    }

    private func lookAround(row: Int, position: Int) -> Set<Int> {
        var numbers = Set<Int>()

        [
            findNumber(row: row - 1, position: position - 1),
            findNumber(row: row - 1, position: position),
            findNumber(row: row - 1, position: position + 1),
            findNumber(row: row, position: position - 1),
            findNumber(row: row, position: position + 1),
            findNumber(row: row + 1, position: position - 1),
            findNumber(row: row + 1, position: position),
            findNumber(row: row + 1, position: position + 1),
        ]
        .compactMap { $0 }
        .forEach { numbers.insert($0) }

        return numbers
    }

    private func findNumber(row: Int, position: Int) -> Int? {
        guard row >= 0, row <= data.count - 1,
              position >= 0, position <= data[row].count - 1
        else {
            return nil
        }

        let symbol = data[row][position]

        guard symbol.isDigit else { return nil }

        var start = position
        var end = position

        while (start - 1) >= 0, data[row][start - 1].isDigit {
            start -= 1
        }
        while (end + 1) < data[row].count, data[row][end + 1].isDigit {
            end += 1
        }

        // Obtain number
        let numberStr = Array(start ... end)
            .map { data[row][$0].value }
            .reduce("") { $0 + $1 }

        return Int(numberStr) ?? 0
    }

    enum EngineChar {
        case zero, one, two, three, four, five, six, seven, eight, nine
        case dot
        case gear
        case symbol

        init(char: Character) {
            switch char {
            case "0": self = .zero
            case "1": self = .one
            case "2": self = .two
            case "3": self = .three
            case "4": self = .four
            case "5": self = .five
            case "6": self = .six
            case "7": self = .seven
            case "8": self = .eight
            case "9": self = .nine
            case ".": self = .dot
            case "*": self = .gear
            default: self = .symbol
            }
        }

        var value: String {
            switch self {
            case .zero: "0"
            case .one: "1"
            case .two: "2"
            case .three: "3"
            case .four: "4"
            case .five: "5"
            case .six: "6"
            case .seven: "7"
            case .eight: "8"
            case .nine: "9"
            case .dot: "."
            case .gear: "*"
            case .symbol: "#"
            }
        }

        var isDigit: Bool {
            switch self {
            case .dot, .gear, .symbol: false
            default: true
            }
        }

        var adjacentsToSymbol: Bool {
            switch self {
            case .gear, .symbol: true
            default: false
            }
        }
    }
}
