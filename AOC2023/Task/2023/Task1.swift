//
//  Task1.swift
//  AOC2023
//
//  Created by Franciszek Czana on 11/12/2023.
//

import Foundation

final class Task1: TaskProvider {
    private let data: [String]

    init(data: [String]) {
        self.data = data
    }

    func solveA() -> Int {
        data.reduce(0) {
            $0 + processString(string: $1, withStrings: false)
        }
    }

    func solveB() -> Int {
        data.reduce(0) {
            $0 + processString(string: $1, withStrings: true)
        }
    }
}

private extension Task1 {
    func processString(string: String, withStrings: Bool) -> Int {
        let leftNumber = findLowerBounds(
            for: string,
            reverseString: false,
            withStrings: withStrings
        )

        let rightNumber = findLowerBounds(
            for: string,
            reverseString: true,
            withStrings: withStrings
        )

        return Int("\(leftNumber)\(rightNumber)") ?? -1
    }

    private func findLowerBounds(for string: String, reverseString: Bool, withStrings: Bool) -> String {
        StrNumber.allCases
            .map { strNumber -> (String, String.Index) in
                string.findBoundingDigits(
                    for: strNumber,
                    reverseString: reverseString,
                    withStrings: withStrings
                )
            }
            .min(by: { $0.1 < $1.1 })
            .map(\.0) ?? ""
    }

    enum StrNumber: String, CaseIterable {
        case one, two, three, four, five, six, seven, eight, nine

        var value: String {
            rawValue
        }

        var reversed: String {
            String(rawValue.reversed())
        }

        var digit: String {
            switch self {
            case .one: "1"
            case .two: "2"
            case .three: "3"
            case .four: "4"
            case .five: "5"
            case .six: "6"
            case .seven: "7"
            case .eight: "8"
            case .nine: "9"
            }
        }
    }
}

private extension String {
    func findBoundingDigits(
        for strNumber: Task1.StrNumber,
        reverseString: Bool,
        withStrings: Bool
    ) -> (String, String.Index) {
        let string = reverseString ? String(reversed()) : self

        // Find by string number
        var lowerBound = string.endIndex
        if withStrings, let rangeLowerBound = string.range(of: reverseString ? strNumber.reversed : strNumber.value)?.lowerBound {
            lowerBound = min(lowerBound, rangeLowerBound)
        }
        // Find by value number
        if let singleLowerBound = string.firstIndex(where: { $0 == Character(strNumber.digit) }) {
            lowerBound = min(lowerBound, singleLowerBound)
        }
        return (strNumber.digit, lowerBound)
    }
}
