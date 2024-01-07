//
//  TaskLoaderServiceTests.swift
//  AOC2023Tests
//
//  Created by Franciszek Czana on 07/01/2024.
//

@testable import AOC2023
import XCTest

final class TaskLoaderServiceTests: XCTestCase {
    func testServiceViaNetwork() async {
        // Given
        let service = makeService()

        // When
        let result = try? await service.getData(taskNumber: "1", viaNetwork: true)

        // Then
        XCTAssertNotNil(result)
        XCTAssert(result?.count == 5)
    }

    func testServiceViaNetworkThrowsError() async {
        // Given
        let service = makeService(apiServiceThrowsError: true)

        // When
        var errorThrown = false
        do {
            try await service.getData(taskNumber: "1", viaNetwork: true)
        } catch {
            errorThrown = true
        }

        // Then
        XCTAssertTrue(errorThrown)
    }

    func testServiceViaFile() async {
        // Given
        let service = makeService()

        // When
        let result = try? await service.getData(taskNumber: "1", viaNetwork: false)

        // Then
        XCTAssertNotNil(result)
        XCTAssert(result?.count == 5)
    }

    func testServiceViaFileThrowsError() async {
        // Given
        let service = makeService(fileServiceThrowsError: true)

        // When
        var errorThrown = false
        do {
            try await service.getData(taskNumber: "1", viaNetwork: false)
        } catch {
            errorThrown = true
        }

        // Then
        XCTAssertTrue(errorThrown)
    }

    func testServiceFileErrorDoNotSpoilNetworkFetch() async {
        // Given
        let service = makeService(fileServiceThrowsError: true)

        let result = try? await service.getData(taskNumber: "1", viaNetwork: true)

        // Then
        XCTAssertNotNil(result)
        XCTAssert(result?.count == 5)
    }

    func testServiceNetworkErrorDoNotSpoilFileLoad() async {
        // Given
        let service = makeService(apiServiceThrowsError: true)

        // When
        let result = try? await service.getData(taskNumber: "1", viaNetwork: false)

        // Then
        XCTAssertNotNil(result)
        XCTAssert(result?.count == 5)
    }

    func testServiceNetworkWrongDataEncode() async {
        // Given
        let service = makeService(apiInvalidEncoding: true)

        // When
        var errorThrown = false
        do {
            try await service.getData(taskNumber: "1", viaNetwork: true)
        } catch {
            errorThrown = true
        }

        // Then
        XCTAssertTrue(errorThrown)
    }

    private func makeService(
        apiServiceThrowsError: Bool = false,
        apiInvalidEncoding: Bool = false,
        fileServiceThrowsError: Bool = false
    ) -> TaskLoaderServiceProtocol {
        let apiService = MockedAPIService()
        apiService.getThrowsError = apiServiceThrowsError
        apiService.dataInvalidEncoding = apiInvalidEncoding

        let fileService = MockedFileService()
        fileService.loadFileThrowsError = fileServiceThrowsError

        return TaskLoaderService(apiService: apiService, fileService: fileService)
    }
}
