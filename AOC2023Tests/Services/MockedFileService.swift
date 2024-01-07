//
//  MockedFileService.swift
//  AOC2023Tests
//
//  Created by Franciszek Czana on 07/01/2024.
//

@testable import AOC2023

import Foundation

final class MockedFileService: FileServiceProtocol {
    var loadFileThrowsError: Bool = false
    func loadFile(fileName _: String, withExtension _: String) throws -> Data {
        if loadFileThrowsError {
            throw FileError.fileNotFound
        }

        return Data("Lorem\nIpsum\nDolor\nSit\nAmet".utf8)
    }
}
