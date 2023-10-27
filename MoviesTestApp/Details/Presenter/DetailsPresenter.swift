//
//  DetailsPresenter.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 24.10.2023.
//

import Foundation
import UIKit

protocol DetailsViewProtocol: NSObjectProtocol {
    func startAnimating()
    func finishAnimating()
    func setupUI(movie: MovieDetails)
}

protocol DetailsPresenterProtocol {
    func fetchDetails()
}

class DetailsPresenter: DetailsPresenterProtocol {
    weak var view: DetailsViewProtocol?
    var movie: MovieDetails? {
        didSet {
            guard let movie = self.movie else {
                return
            }
            self.view?.setupUI(movie: movie)
        }
    }
    var movieId: Int
    let networkService: MoviesAPIProtocol
    var router: RouterProtocol
    
    init(movieId: Int, view: DetailsViewProtocol?, networkService: MoviesAPIProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.movieId = movieId
    }
    
    func fetchDetails() {
        self.view?.startAnimating()
        networkService.getMovieDetails(id: movieId) { [weak self] (movie, error) in
            guard let self = self else { return }
            guard let movie = movie else {
                guard let view = self.view as? UIViewController else { return }
                self.router.popToRoot()
                self.router.showAlert(view: view, title: "Error", description: error?.description ?? "unknown error")
                return
            }
            self.movie = movie
            self.view?.finishAnimating()
        }
    }
    
    func genres(movie: MovieDetails) -> [String] {
        var genresNames: [String] = []
        movie.genres.forEach { genre in
            genresNames.append(genre.name)
        }
        return genresNames
    }
}
