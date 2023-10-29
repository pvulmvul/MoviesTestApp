//
//  DetailsPresenter.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 24.10.2023.
//

import Foundation

protocol DetailsViewProtocol: AnyObject {
    func startAnimating()
    func finishAnimating()
    func setupUI(movie: MovieDetailsViewModel)
}

protocol DetailsPresenterProtocol {
    func fetchDetails()
    func openTrailer()
}

final class DetailsPresenter: DetailsPresenterProtocol {
    private weak var view: DetailsViewProtocol?
    private var movie: MovieDetails? {
        didSet {
            guard let movie = self.movie else {
                return
            }
            let viewModel = MovieDetailsViewModel(
                title: movie.title,
                productionCountriesAndYear: countriesAndYear(),
                genres: genres(),
                posterPath: movie.posterPath,
                overview: movie.overview,
                videos: movie.videos,
                voteAvarage: "Rating".localized() + ": " + String(format: "%.1f", movie.voteAverage)
            )
            self.view?.setupUI(movie: viewModel)
        }
    }
    private var movieId: Int
    private let networkService: MoviesAPIProtocol
    private var router: RouterProtocol
    
    init(movieId: Int, view: DetailsViewProtocol?, networkService: MoviesAPIProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.movieId = movieId
    }
    
    func fetchDetails() {
        view?.startAnimating()
        networkService.getMovieDetails(id: movieId) { [weak self] (movie, error) in
            guard let self = self else { return }
            guard let movie = movie else {
                self.router.popToRoot()
                self.router.showAlert(title: "Error", description: error?.description ?? "unknown error")
                return
            }
            self.movie = movie
            self.view?.finishAnimating()
        }
    }
    
    func openTrailer() {
        guard  let trailerID = movie?.videos.results.first(where: { video in
            video.type == "Trailer"
        })?.key else { return }
        router.showPlayer(id: trailerID)
    }
    
    private func countriesAndYear() -> String {
        guard let movie = movie else { return "" }
        if movie.productionCountries.isEmpty {
            return year(string: movie.releaseDate )
        } else {
            return "\(countries()), \(year(string: movie.releaseDate ))"
        }
    }
    
    private func genres() -> String {
        var genresNames: [String] = []
        
        movie?.genres.forEach { genre in
            genresNames.append(genre.name)
        }
        
        return genresNames.joined(separator: ", ")
    }
    
    private func countries() -> String {
        movie?.productionCountries.map { $0.name }.joined(separator: ", ") ?? ""
    }
    
    private func year(string: String) -> String {
        DateFormatter.dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = DateFormatter.dateFormatter.date(from: string) else { return "" }
        DateFormatter.dateFormatter.dateFormat = "yyyy"
        let year = DateFormatter.dateFormatter.string(from: date)
        return year
    }
}
