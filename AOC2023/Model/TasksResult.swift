//
//  TasksResult.swift
//  AOC2023
//
//  Created by Franciszek Czana on 05/01/2024.
//

import Foundation

struct TasksResult {
    let taskA: TaskResult
    let taskB: TaskResult

    struct TaskResult {
        let value: Int
        let time: TimeInterval
    }
}
