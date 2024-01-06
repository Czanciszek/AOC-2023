//
//  Task8.swift
//  AOC2023
//
//  Created by Franciszek Czana on 27/12/2023.
//

import Foundation

final class Task8: TaskProvider {
    private let data: [String]

    init(data: [String]) {
        self.data = data
    }

    func solveA() -> Int {
        let instructions = parseInstructions()

        guard let startInstruction = instructions.first(where: { $0.value == "AAA" }) else {
            return -1
        }

        return findExit(startInstruction: startInstruction, instructions: instructions)
    }

    func solveB() -> Int {
        let instructions = parseInstructions()

        let startInstructions = instructions.filter { $0.value.hasSuffix("A") }

        let exitSteps = startInstructions.map {
            findExit(startInstruction: $0, instructions: instructions)
        }

        return exitSteps.reduce(1) { lcm($0, $1) }
    }
}

private extension Task8 {
    func parseInstructions() -> [Instruction] {
        data[1...].map { line in
            let parts = String(line)
                .filter { !["(", ")", " "].contains($0) }
                .split(separator: "=")

            let directions = parts[1].split(separator: ",")

            return Instruction(
                value: String(parts[0]),
                left: String(directions[0]),
                right: String(directions[1])
            )
        }
    }

    func findExit(startInstruction: Instruction, instructions: [Instruction]) -> Int {
        guard let directions = data.first else {
            return -1
        }

        var currentInstruction = startInstruction
        var i = 0

        while !currentInstruction.value.hasSuffix("Z") {
            for dir in directions {
                let nextInstruction = instructions.first {
                    if dir == "L" {
                        $0.value == currentInstruction.left
                    } else {
                        $0.value == currentInstruction.right
                    }
                }

                guard let nextInstruction else {
                    return -1
                }

                i += 1
                currentInstruction = nextInstruction
            }
        }

        return i
    }

    struct Instruction {
        let value: String
        let left: String
        let right: String
    }
}

// MARK: Lest Common Multiple

private extension Task8 {
    /*
     Returns the Greatest Common Divisor of two numbers.
     */
    func gcd(_ x: Int, _ y: Int) -> Int {
        var a = 0
        var b = max(x, y)
        var r = min(x, y)

        while r != 0 {
            a = b
            b = r
            r = a % b
        }
        return b
    }

    /*
     Returns the Least Common Multiple of two numbers.
     */
    func lcm(_ x: Int, _ y: Int) -> Int {
        return x / gcd(x, y) * y
    }
}
