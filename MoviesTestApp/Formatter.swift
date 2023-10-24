//
//  Formatter.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 23.10.2023.
//

import Foundation

extension DateFormatter {
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}

