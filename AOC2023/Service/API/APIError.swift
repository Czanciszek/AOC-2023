//
//  APIError.swift
//  AOC2023
//
//  Created by Franciszek Czana on 05/01/2024.
//

import Foundation

enum APIError: LocalizedError {
    case badURL
    case badResponse
    case corruptedData
    case missingCookie
    case statusError(Int)

    var errorDescription: String? {
        switch self {
        case .badURL, .badResponse, .corruptedData: "Something went wrong"
        case .missingCookie: "No cookie found"
        case .statusError: "Network response error"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .badURL, .badResponse: "Try again later"
        case .corruptedData: "data is corrupted"
        case .missingCookie: "Put your cookie data in APIService"
        case let .statusError(code): "Failed with status code: \(code)"
        }
    }
}
