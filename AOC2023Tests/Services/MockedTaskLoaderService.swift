//
//  MockedTaskLoaderService.swift
//  AOC2023Tests
//
//  Created by Franciszek Czana on 07/01/2024.
//

@testable import AOC2023

import Foundation

final class MockedTaskLoaderService: TaskLoaderServiceProtocol {
    var getDataThrowsError: Bool = false
    func getData(taskNumber _: String, viaNetwork _: Bool) async throws -> [String] {
        if getDataThrowsError {
            throw APIError.corruptedData
        }

        return ["Lorem", "Ipsum", "Dolor", "Sit", "Amet"]
    }
}
