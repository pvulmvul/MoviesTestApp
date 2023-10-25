//
//  Extension+String.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 25.10.2023.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
