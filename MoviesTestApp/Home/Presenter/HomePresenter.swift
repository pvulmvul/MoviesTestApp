//
//  HomePresenter.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 24.10.2023.
//

import Foundation
import UIKit

protocol HomeViewProtocol: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func reloadTableView()
}

protocol HomePresenterProtocol {
    func fetchNextPageMovies(index: Int)
    func setMoviesCount() -> Int
    func setMovieModel(index: Int) -> MovieViewModel
    func showDetail(movie: MovieViewModel)
    func handleInternetConnection()
}

class HomePresenter: HomePresenterProtocol {
    
    weak var view: HomeViewProtocol?
    let networkService: MoviesAPIProtocol
    let router: RouterProtocol
    
    var movies: [Movie] = []
    var genres: [Genre] = []
    var currentPage = 1
    var totalPages = 500 //NOTE: In API Response there are 40640 total pages incoming, but in fact it contains only 500, so I hardcoded it too
    
    init(view: HomeViewProtocol, networkService: MoviesAPIProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    
    func handleInternetConnection(){
        if Connectivity.isConnectedToInternet() {
            fetchGenres()
            fetchMovies()
        } else {
            guard let view = self.view as? UIViewController else { return }
            router.showAlert(view: view, title: "You are offline", description: "Please, enable your Wi-Fi or connect using cellular data.")
        }
    }
    
    func fetchNextPageMovies(index: Int) {
        if index == movies.count - 1, currentPage < totalPages {
            fetchMovies()
        }
    }

    func fetchMovies() {
        networkService.getMovies(page: currentPage) { [weak self] (movies, error) in
            guard let self = self else { return }
            guard let movies = movies else {
                guard let view = self.view as? UIViewController else { return }
                self.router.showAlert(view: view, title: "Error", description: error?.description ?? "unknown error")
                return
            }
            
            self.movies += movies
            self.view?.reloadTableView()
        }
        currentPage += 1
    }
    
    func setMoviesCount() -> Int {
        movies.count
    }
    
    func setMovieModel(index: Int) -> MovieViewModel {
        let movieFromAPI = movies[index]
        
        return MovieViewModel(
            id: movieFromAPI.id,
            genres: genres(movie: movieFromAPI),
            overview: movieFromAPI.overview,
            posterPath: movieFromAPI.posterPath,
            releaseDate: movieFromAPI.releaseDate,
            title: movieFromAPI.title,
            video: movieFromAPI.video,
            voteAverage: movieFromAPI.voteAverage
        )
    }
    
    func fetchGenres() {
        networkService.getGenres { [weak self] (genres, error) in
            guard let self = self else { return }
            genres?.forEach({ genre in
                self.genres.append(genre)
            })
        }
    }
    
    func showDetail(movie: MovieViewModel) {
        if Connectivity.isConnectedToInternet() {
            router.showDetail(id: movie.id, title: movie.title)
        } else {
            guard let view = view as? UIViewController else { return }
            router.showAlert(view: view, title: "You are offline", description: "Please, enable your Wi-Fi or connect using cellular data.")
        }
        
    }
    
    func genres(movie: Movie) -> [String] {
        var genresNames: [String] = []
        movie.genreIDS.forEach { id in
            genres.forEach { genre in
                if id == genre.id {
                    genresNames.append(genre.name)
                }
            }
        }
        return genresNames
    }
}
