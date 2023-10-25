//
//  MoviesNetworking.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 24.10.2023.
//

import Foundation
import Alamofire

enum MoviesNetworking {
    case getMovies(page: Int)
    case getGenres
    case getMovieDetails(id: Int)
}

extension MoviesNetworking: TargetType {
    var baseURL: String {
        switch self {
        default:
            return Constant.Server.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .getMovies:
            return "/movie/popular"
        case .getGenres:
            return "/genre/movie/list"
        case .getMovieDetails(let id):
            return "/movie/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getMovies(let page):
            return .requestParameters(parameters: ["page" : page], encoding: URLEncoding.default)
        case .getGenres, .getMovieDetails:
            return .request
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Authorization": "Bearer \(Constant.Server.accessToken)"]
        }
    }
}
