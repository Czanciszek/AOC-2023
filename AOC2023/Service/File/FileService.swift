//
//  FileService.swift
//  AOC2023
//
//  Created by Franciszek Czana on 05/01/2024.
//

import Foundation

final class FileService: FileServiceProtocol {
    func loadFile(fileName: String, withExtension: String) throws -> Data {
        guard let fileUrl = Bundle.main.url(forResource: fileName, withExtension: withExtension) else {
            throw FileError.fileNotFound
        }

        guard let data = try? Data(contentsOf: fileUrl) else {
            throw FileError.corruptedData
        }

        return data
    }
}
