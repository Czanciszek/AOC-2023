//
//  Task7.swift
//  AOC2023
//
//  Created by Franciszek Czana on 26/12/2023.
//

import Foundation

final class Task7: TaskProvider {
    private let data: [String]

    init(data: [String]) {
        self.data = data
    }

    func solveA() -> Int {
        let hands = prepareHands(data: data)
            .sorted(by: { sortCards(left: $0.cards, right: $1.cards) })

        return calculateResult(for: hands)
    }

    func solveB() -> Int {
        let hands = prepareHands(data: data)
            .sorted(by: { sortCards(left: $0.cards, right: $1.cards, taskB: true) })

        return calculateResult(for: hands)
    }

    private func prepareHands(data: [String]) -> [Hand] {
        data
            .compactMap { line in
                let parts = line.split(separator: " ").compactMap { String($0) }
                let cards = parts[0].compactMap { Card(rawValue: String($0)) }
                let points = Int(parts[1]) ?? 0
                return Hand(cards: cards, points: points)
            }
    }

    private func calculateResult(for hands: [Hand]) -> Int {
        hands
            .enumerated()
            .map { index, hand in
                (index + 1) * hand.points
            }
            .reduce(0) { $0 + $1 }
    }

    private func sortCards(left: [Card], right: [Card], taskB: Bool = false) -> Bool {
        let leftPriority = taskB ?
            solveRank2(for: left).priority :
            solveRank(for: left).priority

        let rightPriority = taskB ?
            solveRank2(for: right).priority :
            solveRank(for: right).priority

        if leftPriority != rightPriority {
            return leftPriority < rightPriority
        }

        return solveHighCard(left: left, right: right, taskB: taskB)
    }

    private func solveHighCard(left: [Card], right: [Card], taskB: Bool) -> Bool {
        for i in 0 ..< 5 {
            let leftPriority = left[i].priority(taskB: taskB)
            let rightPriority = right[i].priority(taskB: taskB)

            if leftPriority != rightPriority {
                return leftPriority < rightPriority
            }
        }

        return false
    }
}

// MARK: Task A

extension Task7 {
    private func solveRank(for cards: [Card]) -> RankType {
        let counts = Card.allCases.map { card in
            cards.filter { $0 == card }.count
        }

        if counts.contains(5) {
            return .fiveOfKind
        } else if counts.contains(4) {
            return .fourOfKind
        } else if counts.contains(3) && counts.contains(2) {
            return .fullHouse
        } else if counts.contains(3) {
            return .threeOfKind
        } else if counts.filter({ $0 == 2 }).count == 2 {
            return .twoPair
        } else if counts.filter({ $0 == 2 }).count == 1 {
            return .onePair
        } else {
            return .highCard
        }
    }
}

// MARK: Task B

extension Task7 {
    private func solveRank2(for cards: [Card]) -> RankType {
        let jokerCount = cards.filter { $0 == .J }.count

        let counts = Card.allCases.map { card in
            cards.filter { $0 == card && $0 != .J }.count
        }

        let max = counts.max() ?? 0

        if max + jokerCount == 5 {
            return .fiveOfKind
        }

        if max + jokerCount == 4 {
            return .fourOfKind
        }

        switch jokerCount {
        case 2 where counts.contains(3):
            return .fullHouse
        case 1 where counts.filter({ $0 == 2 }).count == 2:
            return .fullHouse
        case 0 where counts.contains(3) && counts.contains(2):
            return .fullHouse
        default:
            break
        }

        if max + jokerCount == 3 {
            return .threeOfKind
        }

        if max == 2 && jokerCount >= 1 {
            return .twoPair
        }
        if jokerCount == 0 && counts.filter({ $0 == 2 }).count == 2 {
            return .twoPair
        }

        if max == 1 && jokerCount == 1 {
            return .onePair
        }
        if jokerCount == 0 && counts.filter({ $0 == 2 }).count == 1 {
            return .onePair
        }

        return .highCard
    }
}

// MARK: Models

private extension Task7 {
    struct Hand {
        let cards: [Card]
        let points: Int
    }

    enum RankType {
        case fiveOfKind
        case fourOfKind
        case fullHouse
        case threeOfKind
        case twoPair
        case onePair
        case highCard

        var priority: Int {
            switch self {
            case .fiveOfKind: 7
            case .fourOfKind: 6
            case .fullHouse: 5
            case .threeOfKind: 4
            case .twoPair: 3
            case .onePair: 2
            case .highCard: 1
            }
        }
    }

    enum Card: String, CaseIterable {
        case A, K, Q, J, T
        case nine = "9"
        case eight = "8"
        case seven = "7"
        case six = "6"
        case five = "5"
        case four = "4"
        case three = "3"
        case two = "2"

        func priority(taskB: Bool) -> Int {
            switch self {
            case .A: 14
            case .K: 13
            case .Q: 12
            case .J: taskB ? 1 : 11
            case .T: 10
            case .nine: 9
            case .eight: 8
            case .seven: 7
            case .six: 6
            case .five: 5
            case .four: 4
            case .three: 3
            case .two: 2
            }
        }
    }
}
