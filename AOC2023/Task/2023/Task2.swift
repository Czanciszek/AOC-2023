//
//  Task2.swift
//  AOC2023
//
//  Created by Franciszek Czana on 11/12/2023.
//

import Foundation

final class Task2: TaskProvider {
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
        data.enumerated().reduce(0) {
            $0 + processLineB(index: $1.offset, line: $1.element)
        }
    }
}

private extension Task2 {
    func processLineA(index: Int, line: String) -> Int {
        let sets = line
            .split(separator: ":")[1]
            .split(separator: ";")

        let invalidSet = sets.first { set in

            let invalidGem = set
                .split(separator: ",")
                .first { gem in

                    let gemValue = gem.split(separator: " ")
                    guard let gem = Gem(rawValue: String(gemValue[1])),
                          let value = Int(gemValue[0])
                    else {
                        return true
                    }

                    switch gem {
                    case .blue where value > 14: return true
                    case .green where value > 13: return true
                    case .red where value > 12: return true
                    default: break
                    }

                    return false
                }

            return invalidGem != nil
        }

        return invalidSet != nil ? 0 : (index + 1)
    }

    func processLineB(index _: Int, line: String) -> Int {
        let sets = line
            .split(separator: ":")[1]
            .split(separator: ";")

        var red = 0
        var green = 0
        var blue = 0

        sets.forEach { set in
            set.split(separator: ",").forEach { gem in

                let gemValue = gem.split(separator: " ")
                guard let gem = Gem(rawValue: String(gemValue[1])),
                      let value = Int(gemValue[0])
                else {
                    return
                }

                switch gem {
                case .blue: blue = max(blue, value)
                case .green: green = max(green, value)
                case .red: red = max(red, value)
                }
            }
        }

        return (red * green * blue)
    }

    enum Gem: String {
        case green
        case red
        case blue
    }
}
