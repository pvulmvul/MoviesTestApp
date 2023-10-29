//
//  HomePresenter.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 24.10.2023.
//

import Foundation
import UIKit

protocol HomeViewProtocol: AnyObject {
    func startLoading()
    func finishLoading()
    func hideEmptyStateView()
    func showEmptyStateView()
    func reloadTableView()
    func setupNavBar()
}

protocol HomePresenterProtocol {
    func fetchNextPageMovies(index: Int, isSearching: Bool, query: String?)
    func getMoviesCount() -> Int
    func setMovieModel(index: Int) -> MovieViewModel?
    func showDetail(movie: MovieViewModel)
    func fetchData()
    func refreshData()
    func handleSorting()
    func searchMovie(query: String)
    func prepareForAppear()
}

final class HomePresenter: HomePresenterProtocol {
    
    weak var view: HomeViewProtocol?
    private let networkService: MoviesAPIProtocol
    private let router: RouterProtocol
    
    private var movies: [Movie] = []
    private var genres: [Genre] = []
    private var searchedMovies: [Movie] = []
    private var isSearching: Bool = false
    private var currentPage = 1
    private var currentSearchPage = 1
    private var currentQuery: String = ""
    private var currentSortingOption: SortingParameter? = .descending
    private var checkedAction: AlertAction = .descending
    private var totalPages = 500 //NOTE: In API Response there are 40640 total pages incoming, but in fact it contains only 500, so I hardcoded it too
    private var totalSearchPages: Int = 0
    
    init(view: HomeViewProtocol, networkService: MoviesAPIProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    func prepareForAppear() {
        self.view?.setupNavBar()
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
                self.view?.finishLoading()
                self.view?.showEmptyStateView()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.router.showAlert(title: "Error".localized(), description: error.description)
                }
            }
            guard let movies = movies else {
                self.view?.finishLoading()
                return
            }
            
            if movies.results.isEmpty {
                self.view?.showEmptyStateView()
            } else {
                self.view?.hideEmptyStateView()
            }
            
            self.totalSearchPages = movies.totalPages
            self.searchedMovies += movies.results
            self.view?.reloadTableView()
            self.view?.finishLoading()
        }
    }
    
    func handleSorting() {
        if Connectivity.isConnectedToInternet() {
            if self.isSearching {
                self.router.showAlert(title: "Error".localized(), description: "Sorting is not available on search results".localized())
                return
            }
            router.showAlertSheet(checkedAction: checkedAction, title: "", description: "Sorting".localized()) { action in
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
            router.showAlert(title: "Error".localized(), description: "You are offline. Please, enable your Wi-Fi or connect using cellular data.".localized())
        }
    }
    
    private func clearDataSourcesState() {
        self.currentPage = 1
        self.genres.removeAll()
        self.movies.removeAll()
    }
    
    private func fetchMovies() {
        networkService.getMovies(page: currentPage, sortBy: currentSortingOption) { [weak self] (movies, error) in
            guard let self = self else { return }
            if let error = error {
                self.view?.finishLoading()
                self.view?.showEmptyStateView()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.router.showAlert(title: "Error".localized(), description: error.description)
                }
            }
            guard let movies = movies else {
                self.view?.finishLoading()
                return
            }
            
            if movies.results.isEmpty {
                self.view?.showEmptyStateView()
            } else {
                self.view?.hideEmptyStateView()
            }
            
            self.movies += movies.results
            self.view?.reloadTableView()
            self.view?.finishLoading()
        }
        currentPage += 1
    }
    
    func getMoviesCount() -> Int {
        isSearching ? searchedMovies.count : movies.count
    }
    
    func setMovieModel(index: Int) -> MovieViewModel? {
        let movieFromAPI = isSearching ? searchedMovies[index] : movies[index]
        
        return MovieViewModel(
            id: movieFromAPI.id,
            genres: genres(movie: movieFromAPI),
            overview: movieFromAPI.overview,
            posterPath: movieFromAPI.posterPath,
            title: "\(movieFromAPI.title), \(year(string: movieFromAPI.releaseDate))",
            voteAverage: "Rating".localized() + ": " + String(movieFromAPI.voteAverage)
        )
    }
    
    private func fetchGenres() {
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
            router.showAlert(title: "Error".localized(), description: "You are offline. Please, enable your Wi-Fi or connect using cellular data.".localized())
        }
        
    }
    
    private func genres(movie: Movie) -> String {
        var genresNames: [String] = []
        movie.genreIDS.forEach { id in
            genres.forEach { genre in
                if id == genre.id {
                    genresNames.append(genre.name)
                }
            }
        }
        return genresNames.joined(separator: ", ")
    }
    
    private func year(string: String) -> String {
        DateFormatter.dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = DateFormatter.dateFormatter.date(from: string) else { return "" }
        DateFormatter.dateFormatter.dateFormat = "yyyy"
        let year = DateFormatter.dateFormatter.string(from: date)
        return year
    }
}
