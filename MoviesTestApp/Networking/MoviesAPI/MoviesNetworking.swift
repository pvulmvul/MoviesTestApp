//
//  MoviesNetworking.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 24.10.2023.
//

import Foundation
import Alamofire

enum MoviesNetworking {
    case getMovies(page: Int, sortBy: SortingParameter?)
    case getGenres
    case getMovieDetails(id: Int)
    case searchMovie(page: Int, query: String)
}

enum SortingParameter {
    case ascending
    case descending
    
    var param: String {
        switch self {
        case .ascending: return "popularity.asc"
        case .descending: return "popularity.desc"
        }
    }
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
            return "/discover/movie"
        case .getGenres:
            return "/genre/movie/list"
        case .getMovieDetails(let id):
            return "/movie/\(id)"
        case .searchMovie:
            return "/search/movie"
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
        case .getMovies(let page, let parameter):
            return .requestParameters(parameters: [
                "page": page,
                "sort_by": parameter?.param ?? "popularity.desc"
            ], encoding: URLEncoding.default)
        case .getGenres:
            return .request
        case .getMovieDetails:
            return .requestParameters(parameters: ["append_to_response": "videos"], encoding: URLEncoding.default)
        case .searchMovie(let page, let query):
            return .requestParameters(parameters: [
                "page": page,
                "query": query
            ], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Authorization": "Bearer \(Constant.Server.accessToken)"]
        }
    }
}
