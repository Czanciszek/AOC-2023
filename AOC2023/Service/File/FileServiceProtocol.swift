//
//  FileServiceProtocol.swift
//  AOC2023
//
//  Created by Franciszek Czana on 06/01/2024.
//

import Foundation

protocol FileServiceProtocol {
    func loadFile(fileName: String, withExtension: String) throws -> Data
}

extension FileServiceProtocol {
    func loadFile(fileName: String) throws -> Data {
        try loadFile(fileName: fileName, withExtension: "txt")
    }
}
