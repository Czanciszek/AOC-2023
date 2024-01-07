//
//  MainViewModelTests.swift
//  AOC2023Tests
//
//  Created by Franciszek Czana on 05/01/2024.
//

@testable import AOC2023
import XCTest

final class MainViewModelTests: XCTestCase {
    func testViewModelEntryProperties() {
        // Given
        let viewModel = makeViewModel()

        // When

        // Then
        XCTAssertNil(viewModel.error)
        XCTAssertNil(viewModel.currentTaskResult)
        XCTAssertFalse(viewModel.inProgress)
        XCTAssertTrue(viewModel.networkToggle)
    }

    func testSelectedTask() async {
        // Given
        let viewModel = makeViewModel()

        // When
        let task = Task { await viewModel.selectedTask(taskNumber: "2") }
        await task.value

        // Then
        XCTAssertNil(viewModel.error)
        XCTAssertNotNil(viewModel.currentTaskResult)
        XCTAssertFalse(viewModel.inProgress)
    }

    func testSelectedTaskThrowsError() async {
        // Given
        let viewModel = makeViewModel(throwsError: true)

        // When
        let task = Task { await viewModel.selectedTask(taskNumber: "2") }
        await task.value

        // Then
        XCTAssertNotNil(viewModel.error)
        XCTAssertNil(viewModel.currentTaskResult)
        XCTAssertFalse(viewModel.inProgress)
    }

    private func makeViewModel(throwsError: Bool = false) -> MainViewModel {
        let taskLoaderService = MockedTaskLoaderService()
        taskLoaderService.getDataThrowsError = throwsError

        return MainViewModel(
            taskLoaderService: taskLoaderService,
            taskSolverService: MockedTaskSolverService()
        )
    }
}
