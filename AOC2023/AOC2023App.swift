//
//  AOC2023App.swift
//  AOC2023
//
//  Created by Franciszek Czana on 05/01/2024.
//

import SwiftUI

@main
struct AOC2023App: App {
    let viewModel = MainViewModel()

    var body: some Scene {
        WindowGroup {
            MainView(viewModel: viewModel)
        }
    }
}
