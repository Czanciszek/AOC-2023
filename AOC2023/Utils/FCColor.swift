//
//  FCColor.swift
//  AOC2023
//
//  Created by Franciszek Czana on 06/01/2024.
//

import SwiftUI

enum FCColor: String {
    case background = "Background"
    case foreground = "Foreground"
    case textColor = "TextColor"

    var color: Color {
        Color(rawValue)
    }

    func color(opacity: CGFloat) -> Color {
        color.opacity(opacity)
    }
}
