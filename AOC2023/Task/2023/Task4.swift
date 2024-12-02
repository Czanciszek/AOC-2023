//
//  Task4.swift
//  AOC2023
//
//  Created by Franciszek Czana on 13/12/2023.
//

import Foundation

final class Task4: TaskProvider {
    private let data: [String]

    init(data: [String]) {
        self.data = data
    }

    func solveA() -> Int {
        data.enumerated().reduce(0) {
            $0 + processLineA(index: $1.offset, line: $1.element)
        }
    }

    func solveB() -> Int {
        var cardDict: [Int: Int] = [:]

        data.enumerated().forEach { index, line in

            let cardNumber = index + 1

            let cards = line
                .split(separator: ":")[1]
                .split(separator: "|")

            let winningSet = obtainCardSet(for: cards[0])
            let havingSet = obtainCardSet(for: cards[1])

            let winCount = winningSet.intersection(havingSet).count

            let copies = (cardDict[cardNumber] ?? 0) + 1
            cardDict[cardNumber] = copies

            if winCount > 0 {
                for i in 1 ... winCount {
                    cardDict[cardNumber + i] = copies + (cardDict[cardNumber + i] ?? 0)
                }
            }
        }

        return cardDict.values.reduce(0) { $0 + $1 }
    }
}

private extension Task4 {
    func processLineA(index _: Int, line: String) -> Int {
        let cards = line
            .split(separator: ":")[1]
            .split(separator: "|")

        let winningSet = obtainCardSet(for: cards[0])
        let havingSet = obtainCardSet(for: cards[1])

        let winSet = winningSet.intersection(havingSet)
        let score = pow(2, winSet.count - 1)

        return score.isNormal ? NSDecimalNumber(decimal: score).intValue : 0
    }

    func obtainCardSet(for numbers: String.SubSequence) -> Set<Int> {
        var set = Set<Int>()

        numbers
            .split(separator: " ")
            .compactMap { Int(String($0)) }
            .forEach { set.insert($0) }

        return set
    }
}
