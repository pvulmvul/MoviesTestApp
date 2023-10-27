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
    func fetchNextPageMovies(index: Int, isSearching: Bool, query: String?)
    func setMoviesCount() -> Int
    func setMovieModel(index: Int) -> MovieViewModel?
    func showDetail(movie: MovieViewModel)
    func fetchData()
    func refreshData()
    func handleSorting()
    func searchMovie(query: String)
}

class HomePresenter: HomePresenterProtocol {
    
    weak var view: HomeViewProtocol?
    let networkService: MoviesAPIProtocol
    let router: RouterProtocol
    
    var movies: [Movie] = []
    var genres: [Genre] = []
    var searchedMovies: [Movie] = []
    var isSearching: Bool = false
    var currentPage = 1
    var currentSearchPage = 1
    var currentQuery: String = ""
    var currentSortingOption: SortingParameter? = .descending
    var checkedAction: UIAlertAction?
    var totalPages = 500 //NOTE: In API Response there are 40640 total pages incoming, but in fact it contains only 500, so I hardcoded it too
    var totalSearchPages: Int = 0
    
    init(view: HomeViewProtocol, networkService: MoviesAPIProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    
    func refreshData() {
        genres.removeAll()
        movies.removeAll()
        currentPage = 1
        fetchGenres()
        fetchMovies()
    }
    
    func fetchData() {
        isSearching = false
        clearDataSourcesState()
        self.view?.startLoading()
        fetchGenres()
        fetchMovies()
    }
    
    func fetchNextPageMovies(index: Int, isSearching: Bool, query: String?) {
        if isSearching {
            if index == searchedMovies.count - 1, currentSearchPage < totalSearchPages {
                currentSearchPage += 1
                guard let query = query else { return }
                searchMovie(query: query)
            }
        } else {
            if index == movies.count - 1, currentPage < totalPages {
                fetchMovies()
            }
        }
    }
    
    func searchMovie(query: String) {
        isSearching = true
        if currentQuery != query {
            currentSearchPage = 1
            searchedMovies.removeAll()
        }
        networkService.searchMovie(page: currentSearchPage, query: query) { [weak self] (movies, error) in
            guard let self = self else { return }
            self.currentQuery = query
            if let error = error {
                guard let view = self.view as? UIViewController else { return }
                self.view?.finishLoading()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.router.showAlert(view: view, title: "Error".localized(), description: error.description)
                }
            }
            guard let movies = movies else {
                self.view?.finishLoading()
                return
            }
            
            self.totalSearchPages = movies.totalPages
            self.searchedMovies += movies.results
            self.view?.reloadTableView()
            self.view?.finishLoading()
        }
    }
    
    func handleSorting() {
        guard let view = self.view as? UIViewController else { return }
        if Connectivity.isConnectedToInternet() {
            if self.isSearching {
                self.router.showAlert(view: view, title: "Error".localized(), description: "Sorting is not available on search results".localized())
                return
            }
            router.showAlertSheet(checkedAction: checkedAction, view: view, title: "", description: "Sorting".localized()) { action in
                action.setValue(true, forKey: "checked")
                self.checkedAction = action
                switch action.title {
                case "Ascending".localized():
                    self.currentSortingOption = .ascending
                    self.clearDataSourcesState()
                    self.fetchData()
                case "Descending".localized():
                    self.clearDataSourcesState()
                    self.currentSortingOption = .descending
                    self.fetchData()
                default: return
                }
            }
        } else {
            router.showAlert(view: view, title: "Error".localized(), description: "You are offline. Please, enable your Wi-Fi or connect using cellular data.".localized())
        }
    }
    
    func clearDataSourcesState() {
        self.currentPage = 1
        self.genres.removeAll()
        self.movies.removeAll()
    }
    
    func fetchMovies() {
        networkService.getMovies(page: currentPage, sortBy: currentSortingOption) { [weak self] (movies, error) in
            guard let self = self else { return }
            if let error = error {
                guard let view = self.view as? UIViewController else { return }
                self.view?.finishLoading()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.router.showAlert(view: view, title: "Error".localized(), description: error.description)
                }
            }
            guard let movies = movies else {
                self.view?.finishLoading()
                return
            }
            
            self.movies += movies.results
            self.view?.reloadTableView()
            self.view?.finishLoading()
        }
        currentPage += 1
    }
    
    func setMoviesCount() -> Int {
        isSearching ? searchedMovies.count : movies.count
    }
    
    func setMovieModel(index: Int) -> MovieViewModel? {
        let movieFromAPI = isSearching ? searchedMovies[index] : movies[index]
        
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
            router.showAlert(view: view, title: "Error".localized(), description: "You are offline. Please, enable your Wi-Fi or connect using cellular data.".localized())
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
