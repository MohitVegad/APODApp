//
//  StringExtension.swift
//  APOD App
//
//  Created by Mohit Vegad on 28/10/2025.
//

import Foundation

import Foundation

extension String {

    var formattedLongDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = kFormatDate
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let date = inputFormatter.date(from: self) else {
            return self
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .long
        outputFormatter.locale = Locale(identifier: "en_US")
        
        return outputFormatter.string(from: date)
    }
}
