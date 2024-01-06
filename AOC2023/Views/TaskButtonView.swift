//
//  TaskButtonView.swift
//  AOC2023
//
//  Created by Franciszek Czana on 05/01/2024.
//

import SwiftUI

enum TaskButtonViewConstants {
    static let taskLabel = "Task"
    static let imageNumber = "%@.circle.fill"
}

struct TaskButtonView: View {
    private typealias Constants = TaskButtonViewConstants

    let taskNumber: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Text(Constants.taskLabel)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: String(format: Constants.imageNumber, taskNumber))
                    .font(.largeTitle)
            }
            .padding(8)
        }
        .foregroundColor(FCColor.textColor.color)
        .background(FCColor.foreground.color)
        .cornerRadius(8)
    }
}

#Preview {
    VStack {
        TaskButtonView(taskNumber: "4", action: {})

        HStack {
            TaskButtonView(taskNumber: "1", action: {})
            TaskButtonView(taskNumber: "8", action: {})
            TaskButtonView(taskNumber: "12", action: {})
        }
    }
}
