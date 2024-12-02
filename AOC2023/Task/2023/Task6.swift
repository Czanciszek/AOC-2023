//
//  Task6.swift
//  AOC2023
//
//  Created by Franciszek Czana on 25/12/2023.
//

import Foundation

final class Task6: TaskProvider {
    private let data: [String]

    init(data: [String]) {
        self.data = data
    }

    func solveA() -> Int {
        let times = data[0]
            .split(separator: " ")
            .compactMap { Double($0) }

        let distances = data[1]
            .split(separator: " ")
            .compactMap { Double($0) }

        return times.enumerated().reduce(1) {
            $0 * calculateWays(time: $1.element, distance: distances[$1.offset])
        }
    }

    func solveB() -> Int {
        let timeStr = data[0]
            .split(separator: " ")
            .compactMap { Int($0) }
            .reduce("") { $0 + "\($1)" }

        let distanceStr = data[1]
            .split(separator: " ")
            .compactMap { Int($0) }
            .reduce("") { $0 + "\($1)" }

        guard let time = Double(timeStr),
              let distance = Double(distanceStr)
        else {
            return -1
        }

        return calculateWays(time: time, distance: distance)
    }

    private func calculateWays(time: Double, distance: Double) -> Int {
        let sqrtDelta = sqrt((time * time) - (4 * distance))

        let t1: Double = (time - sqrtDelta) / 2
        let t2: Double = (time + sqrtDelta) / 2

        let start = ceil(t1) == t1 ? (t1 + 1) : ceil(t1)
        let end = floor(t2) == t2 ? (t2 - 1) : floor(t2)

        return Int(end - start + 1)
    }
}
