//
//  DetailsViewController.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 25.10.2023.
//

import UIKit
import Lottie

class DetailsViewController: UIViewController {
    
    @IBOutlet private weak var loaderView: UIView!
    @IBOutlet weak var lottieLoader: LottieAnimationView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var countryYearLabel: UILabel!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var contentView: UIView!
    
    var detailsPresenter: DetailsPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLoader()
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        //OPEN video player
    }
    
    func fetchDetails() {
        guard let detailsPresenter = detailsPresenter else { return }
        detailsPresenter.fetchDetails()
    }
    
    func setupLoader() {
        lottieLoader.loopMode = .loop
    }
    
    func genres(_ genres: [Genre]) -> String {
        genres.map { $0.name }.joined(separator: ", ")
    }
    
    func countries(_ counries: [ProductionCountry]) -> String {
        counries.map { $0.name }.joined(separator: ", ")
    }
}

extension DetailsViewController: DetailsViewProtocol {
    
    func startAnimating() {
        loaderView.isHidden = false
        lottieLoader.play()
    }
    
    func finishAnimating() {
        loaderView.isHidden = true
        lottieLoader.stop()
    }
    
    func setupUI(movie: MovieDetails) {
        descriptionLabel.text = movie.overview
        ratingLabel.text = "Rating".localized() + ": " + String(movie.voteAverage)
        genresLabel.text = genres(movie.genres)
        posterImageView.loadImage(imagePath: Constant.Server.imageURL + movie.posterPath)
        movieTitleLabel.text = movie.title
        DateFormatter.dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = DateFormatter.dateFormatter.date(from: movie.releaseDate) else { return }
        DateFormatter.dateFormatter.dateFormat = "yyyy"
        let year = DateFormatter.dateFormatter.string(from: date)
        countryYearLabel.text = "\(countries(movie.productionCountries)), \(year)"
        playButton.isHidden = !movie.video
    }
}
