//
//  DetailsViewController.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 25.10.2023.
//

import UIKit
import Lottie
import Lightbox

class DetailsViewController: UIViewController {
    
    @IBOutlet private weak var loaderView: UIView!
    @IBOutlet private weak var lottieLoader: LottieAnimationView!
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
        guard let detailsPresenter = detailsPresenter else { return }
        detailsPresenter.openTrailer()
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
        ratingLabel.text = "Rating".localized() + ": " + String(format: "%.1f", movie.voteAverage)
        genresLabel.text = genres(movie.genres)
        posterImageView.loadImage(imagePath: Constant.Server.imageURL + (movie.posterPath ?? ""))
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapImage))
        posterImageView.addGestureRecognizer(tap)
        movieTitleLabel.text = movie.title
        if countries(movie.productionCountries).isEmpty {
            countryYearLabel.text = year(string: movie.releaseDate)
        } else {
            countryYearLabel.text = "\(countries(movie.productionCountries)), \(year(string: movie.releaseDate))"
        }
        playButton.isHidden = movie.videos.results.isEmpty
    }
    
    @objc func didTapImage() {
        if let image = posterImageView.image {
            if image != Constant.Media.imagePlaceholder {
                let controller = LightboxController(images: [LightboxImage(image: image)])
                controller.modalPresentationStyle = .fullScreen
                LightboxConfig.PageIndicator.enabled = false
                present(controller, animated: true)
            }
        }
    }
    
    func year(string: String) -> String {
        DateFormatter.dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = DateFormatter.dateFormatter.date(from: string) else { return "" }
        DateFormatter.dateFormatter.dateFormat = "yyyy"
        let year = DateFormatter.dateFormatter.string(from: date)
        return year
    }
}
