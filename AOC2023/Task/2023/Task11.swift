//
//  Task11.swift
//  AOC2023
//
//  Created by Franciszek Czana on 08/01/2024.
//

import Foundation

final class Task11: TaskProvider {
    private let data: [String]

    init(data: [String]) {
        self.data = data
    }

    func solveA() -> Int {
        solveTask(spreadFactor: 2)
    }

    func solveB() -> Int {
        solveTask(spreadFactor: 1_000_000)
    }

    private func solveTask(spreadFactor: Int) -> Int {
        let galaxies = data
            .enumerated()
            .flatMap { rowIndex, row in
                row
                    .enumerated()
                    .filter { $0.element == "#" }
                    .map { Galaxy(x: rowIndex, y: $0.offset) }
            }

        return calculatePairDistances(for: galaxies, spreadFactor: spreadFactor)
    }

    private func calculatePairDistances(for galaxies: [Galaxy], spreadFactor: Int) -> Int {
        let (rows, columns) = findEmptySpace()

        var result = 0
        for (galaxyIndex, galaxy) in galaxies.enumerated() {
            for pairedIndex in (galaxyIndex + 1) ..< galaxies.count {
                let pairGalaxy = galaxies[pairedIndex]

                let spreadedRowsCount = rows
                    .filter {
                        $0 > min(galaxy.x, pairGalaxy.x) &&
                            $0 < max(galaxy.x, pairGalaxy.x)
                    }
                    .count * (spreadFactor - 1)

                let spreadedColumnsCount = columns
                    .filter {
                        $0 > min(galaxy.y, pairGalaxy.y) &&
                            $0 < max(galaxy.y, pairGalaxy.y)
                    }
                    .count * (spreadFactor - 1)

                let distance =
                    abs(galaxy.x - pairGalaxy.x) + spreadedRowsCount +
                    abs(galaxy.y - pairGalaxy.y) + spreadedColumnsCount
                result += distance
            }
        }

        return result
    }

    private func findEmptySpace() -> ([Int], [Int]) {
        let emptyRows = data
            .enumerated()
            .filter { !$0.element.contains("#") }
            .map(\.offset)

        let filledColumns = data
            .flatMap { row in
                row
                    .enumerated()
                    .filter { $0.element == "#" }
                    .map(\.offset)
            }

        let emptyColumns = Array(0 ..< data[0].count)
            .filter { !filledColumns.contains($0) }

        return (emptyRows, emptyColumns)
    }

    struct Galaxy {
        let x: Int
        let y: Int
    }
}
