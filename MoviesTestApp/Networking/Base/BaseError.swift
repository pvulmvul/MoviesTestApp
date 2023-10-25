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
    
    var description: String {
        switch self {
        case .notFound: return "The resource is not found"
        case .serverError: return "Internal server error"
        case .unknown: return "Unknown error"
        case .badRequest: return "Bad request"
        case .forbidden: return "Forbidden"
        case .unauthorized: return "You are not authorized"
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
