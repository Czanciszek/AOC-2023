//
//  ContentView.swift
//  AOC2023
//
//  Created by Franciszek Czana on 05/01/2024.
//

import SwiftUI

private typealias Constants = MainConstants

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        ScrollView {
            title
            taskList
            fetchToggle
            if let result = viewModel.currentTaskResult {
                taskResult(result)
            }
        }
        .padding()
        .background(FCColor.background.color)
        .errorAlert(error: $viewModel.error)
        .loadable(
            isLoading: viewModel.inProgress,
            label: Constants.Text.solving
        )
    }

    private var title: some View {
        Text(Constants.Text.title)
            .multilineTextAlignment(.center)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(FCColor.textColor.color)
            .frame(maxWidth: .infinity, alignment: .center)
    }

    private var taskList: some View {
        let gridColumns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]

        return ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 24) {
                ForEach(Constants.Data.taskNumbers, id: \.self) { number in
                    TaskButtonView(taskNumber: number) {
                        Task {
                            await viewModel.selectedTask(taskNumber: number)
                        }
                    }
                }
            }
        }
        .padding(8)
        .frame(maxHeight: 280)
        .background(FCColor.foreground.color(opacity: 0.5))
        .cornerRadius(8)
    }

    private var fetchToggle: some View {
        let toggleTitle: String = $viewModel.networkToggle.wrappedValue ?
            Constants.Text.useNetworkConnection :
            Constants.Text.loadDataFromFile

        return Toggle(isOn: $viewModel.networkToggle) {
            Text(toggleTitle)
                .font(.caption)
                .foregroundColor(FCColor.textColor.color)
        }
        .padding()
        .background(FCColor.foreground.color(opacity: 0.5))
        .cornerRadius(8)
    }

    private func taskResult(_ result: TasksResult) -> some View {
        HStack {
            TaskResultView(
                title: Constants.Text.taskA,
                result: result.taskA
            )
            TaskResultView(
                title: Constants.Text.taskB,
                result: result.taskB
            )
        }
    }

    private struct TaskResultView: View {
        let title: String
        let result: TasksResult.TaskResult

        var body: some View {
            VStack {
                Group {
                    Text(title)
                        .fontWeight(.bold)

                    HStack(spacing: 4) {
                        Text(Constants.Text.taskResult)
                        Text("\(result.value)")
                            .fontWeight(.bold)
                    }

                    Text(String(format: Constants.Text.taskTime, result.time.formattedValue))
                }
                .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 20)
            .foregroundColor(FCColor.textColor.color)
            .background(FCColor.foreground.color)
            .cornerRadius(8)
        }
    }
}

#Preview {
    MainView(viewModel: MainViewModel())
}
