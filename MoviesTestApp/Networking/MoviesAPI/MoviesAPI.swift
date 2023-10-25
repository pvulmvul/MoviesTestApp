//
//  MoviesAPI.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 24.10.2023.
//

import Foundation

typealias MoviesCompletion = ([Movie]?, NetworkError?) -> Void
typealias GenresCompletion = ([Genre]?, NetworkError?) -> Void
typealias MovieDetailsCompletion = (MovieDetails?, NetworkError?) -> Void

protocol MoviesAPIProtocol {
    func getMovies(page: Int, completionHandler: @escaping MoviesCompletion)
    func getGenres(completionHandler: @escaping GenresCompletion)
    func getMovieDetails(id: Int, completionHandler: @escaping MovieDetailsCompletion)
}


final class MoviesAPI: API<MoviesNetworking>, MoviesAPIProtocol {
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
                completionHandler(genres.genres, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func getMovieDetails(id: Int, completionHandler: @escaping MovieDetailsCompletion) {
        self.fetchData(target: .getMovieDetails(id: id), responseClass: MovieDetails.self) { result in
            switch result {
            case .success(let details):
                DispatchQueue.main.async {
                    completionHandler(details, nil)
                }
                
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
}
