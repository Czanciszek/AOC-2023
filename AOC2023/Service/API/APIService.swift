//
//  APIService.swift
//  AOC2023
//
//  Created by Franciszek Czana on 05/01/2024.
//

import AVFoundation

protocol APIServiceProtocol {
    func get(taskNumber: String) async throws -> Data
}

final class APIService: APIServiceProtocol {
    private let cookie = ""

    func get(taskNumber: String) async throws -> Data {
        let url = URL(string: "https://adventofcode.com/2023/day/\(taskNumber)/input")!

        if cookie.isEmpty {
            throw APIError.missingCookie
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(cookie, forHTTPHeaderField: "Cookie")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let urlResponse = response as? HTTPURLResponse else {
            throw APIError.badResponse
        }

        guard (200 ... 299).contains(urlResponse.statusCode) else {
            throw APIError.statusError(urlResponse.statusCode)
        }

        return data
    }
}
