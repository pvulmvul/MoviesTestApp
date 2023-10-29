//
//  AlertAction.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 29.10.2023.
//

import Foundation

enum AlertAction {
    case descending
    case ascending
    
    var title: String {
        switch self {
        case .descending: return "Descending".localized()
        case .ascending: return "Ascending".localized()
        }
    }
}
