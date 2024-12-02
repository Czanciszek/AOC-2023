//
//  MainConstants.swift
//  AOC2023
//
//  Created by Franciszek Czana on 05/01/2024.
//

enum MainConstants {
    private static let maxTaskNumber: Int = 12

    enum Data {
        static let taskNumbers: [String] = Array(1 ... maxTaskNumber)
            .compactMap { "\($0)" }
    }

    enum Text {
        static let title = "Advent of Code %@ Solver"

        static let useNetworkConnection = "Use Network Connection"
        static let loadDataFromFile = "Load data from file"

        static let taskA = "Task A"
        static let taskB = "Task B"
        static let taskResult = "Result: "
        static let taskTime = "Time taken: %@s"

        static let solving = "Solving..."
    }
}
