//
//  MockedTaskSolverService.swift
//  AOC2023Tests
//
//  Created by Franciszek Czana on 07/01/2024.
//

@testable import AOC2023

import Foundation

final class MockedTaskSolverService: TaskSolverServiceProtocol {
    func solve(taskNumber _: String, data _: [String]) throws -> TasksResult {
        TasksResult.mock
    }
}

extension TasksResult {
    static var mock: Self {
        .init(
            taskA: .init(value: 20, time: 40),
            taskB: .init(value: 40, time: 100)
        )
    }
}
