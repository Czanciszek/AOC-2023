//
//  Task9.swift
//  AOC2023
//
//  Created by Franciszek Czana on 30/12/2023.
//

import Foundation

final class Task9: TaskProvider {
    private let data: [[Int]]

    init(data: [String]) {
        self.data = data
            .map { $0.split(separator: " ").compactMap { Int($0) } }
    }

    func solveA() -> Int {
        data.reduce(0) { $0 + solveSequence(sequence: $1) }
    }

    func solveB() -> Int {
        data.reduce(0) { $0 + solveSequence(sequence: $1, takePrefix: true) }
    }

    private func solveSequence(sequence: [Int], takePrefix: Bool = false) -> Int {
        var extrapolatedSequence = extrapolateSequence(sequence: sequence)

        for i in 1 ..< extrapolatedSequence.count {
            let index = extrapolatedSequence.count - i

            let originValue = takePrefix ?
                extrapolatedSequence[index].first :
                extrapolatedSequence[index].last

            let nextValue = takePrefix ?
                extrapolatedSequence[index - 1].first :
                extrapolatedSequence[index - 1].last

            guard let originValue, let nextValue else {
                return -1
            }

            if takePrefix {
                extrapolatedSequence[index - 1].insert(nextValue - originValue, at: 0)
            } else {
                extrapolatedSequence[index - 1].append(originValue + nextValue)
            }
        }

        let result = takePrefix ?
            extrapolatedSequence.first?.first :
            extrapolatedSequence.first?.last

        return result ?? -1
    }

    private func extrapolateSequence(sequence: [Int]) -> [[Int]] {
        var filledSequence: [[Int]] = [sequence]

        var subsequence = sequence
        while subsequence.contains(where: { $0 != 0 }) {
            subsequence = makeSubsequence(subsequence: subsequence)
            filledSequence.append(subsequence)
        }

        return filledSequence
    }

    private func makeSubsequence(subsequence: [Int]) -> [Int] {
        subsequence.enumerated()
            .compactMap { index, value -> Int? in
                guard index < subsequence.count - 1 else { return nil }
                return subsequence[index + 1] - value
            }
    }
}
