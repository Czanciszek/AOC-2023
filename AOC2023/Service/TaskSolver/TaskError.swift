//
//  TaskError.swift
//  AOC2023
//
//  Created by Franciszek Czana on 06/01/2024.
//

import Foundation

enum TaskError: LocalizedError {
    case unknownTask
    case notSolvedYet

    var errorDescription: String? {
        switch self {
        case .unknownTask: "Something went wrong"
        case .notSolvedYet: "Task is not solved yet"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .unknownTask: "Unknown taskNumber"
        case .notSolvedYet: "Work on it!"
        }
    }
}
