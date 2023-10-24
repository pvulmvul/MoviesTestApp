//
//  MoviesAPI.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 24.10.2023.
//

import Foundation

typealias MoviesCompletion = ([MoviesResult]?, NetworkError?) -> Void
typealias GenresCompletion = (Genres?, NetworkError?) -> Void

protocol MoviesAPIProtocol {
    func getMovies(page: Int, completionHandler: @escaping MoviesCompletion)
    func getGenres(completionHandler: @escaping GenresCompletion)
}


class MoviesAPI: API<MoviesNetworking>, MoviesAPIProtocol {
    func getMovies(page: Int, completionHandler: @escaping MoviesCompletion) {
        self.fetchData(target: .getMovies(page: page), responseClass: Movies.self) { result in
            switch result {
            case .success(let movies):
                completionHandler(movies.results, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func getGenres(completionHandler: @escaping GenresCompletion) {
        self.fetchData(target: .getGenres, responseClass: Genres.self) { result in
            switch result {
            case .success(let genres):
                completionHandler(genres, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
}
