//
//  FileError.swift
//  AOC2023
//
//  Created by Franciszek Czana on 05/01/2024.
//

import Foundation

enum FileError: LocalizedError {
    case fileNotFound
    case corruptedData

    var errorDescription: String? {
        "Something went wrong"
    }

    var recoverySuggestion: String? {
        switch self {
        case .fileNotFound: "File was not found"
        case .corruptedData: "Data is corrupted"
        }
    }
}
