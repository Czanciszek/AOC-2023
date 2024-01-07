//
//  MockedAPIService.swift
//  AOC2023Tests
//
//  Created by Franciszek Czana on 07/01/2024.
//

@testable import AOC2023

import Foundation

final class MockedAPIService: APIServiceProtocol {
    var getThrowsError: Bool = false
    var dataInvalidEncoding: Bool = false
    func get(taskNumber _: String) async throws -> Data {
        if getThrowsError {
            throw APIError.badURL
        }

        let str = "Lorem\nIpsum\nDolor\nSit\nAmet"
        return dataInvalidEncoding ? str.data(using: .utf16)! : Data(str.utf8)
    }
}
