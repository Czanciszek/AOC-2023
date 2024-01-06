//
//  TimeInterval+TimeFormatter.swift
//  AOC2023
//
//  Created by Franciszek Czana on 06/01/2024.
//

import Foundation

extension TimeInterval {
    private static var timeFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 3
        formatter.maximumFractionDigits = 3
        return formatter
    }()

    var formattedValue: String {
        let number = NSNumber(value: self)
        return Self.timeFormatter.string(from: number) ?? ""
    }
}
