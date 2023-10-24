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
    case ok
    case defaultError
    
    var description: String {
        switch self {
        case .notFound: return "NOT FOUND"
        case .serverError: return "SERVER ERROR"
        case .unknown: return "UNKNOWN ERROR"
        case .badRequest: return "BAD REQUEST"
        case .forbidden: return "FORBIDDEN"
        case .ok: return "SUCCESS"
        case .defaultError: return "ERROR"
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
