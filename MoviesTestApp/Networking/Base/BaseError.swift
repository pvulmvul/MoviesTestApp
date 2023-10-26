//
//  BaseError.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 24.10.2023.
//

import Foundation

enum NetworkError: Error {
    case notFound
    case serverError
    case unknown
    case badRequest
    case forbidden
    case unauthorized
    case noInternetConnection
    
    var description: String {
        switch self {
        case .notFound: return "The resource is not found".localized()
        case .serverError: return "Internal server error".localized()
        case .unknown: return "Unknown error".localized()
        case .badRequest: return "Bad request".localized()
        case .forbidden: return "Forbidden".localized()
        case .unauthorized: return "You are not authorized".localized()
        case .noInternetConnection: return "You are offline. Please, enable your Wi-Fi or connect using cellular data.".localized()
        }
    }
}

enum StatusCode: Int {
    case unknownCode = 0
    case lostInternetConnection = 1
    
    case ok = 200
    case created = 201
    case accepted = 202
    case noContent = 204
    
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case conflict = 409
    
    case imAteapot = 418
    
    case internalServerError = 500
    
    init(fromCode: Int?) {
        self = StatusCode(rawValue: fromCode ?? 0) ?? .unknownCode
    }
}
