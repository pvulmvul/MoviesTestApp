//
//  DetailsViewController.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 25.10.2023.
//

import UIKit
import Lottie
import Lightbox

final class DetailsViewController: UIViewController {
    
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
        detailsPresenter?.fetchDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLoader()
    }
    
    @IBAction private func playButtonPressed(_ sender: Any) {
        guard let detailsPresenter = detailsPresenter else { return }
        detailsPresenter.openTrailer()
    }
    
    private func setupLoader() {
        lottieLoader.loopMode = .loop
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
    
    func setupUI(movie: MovieDetailsViewModel) {
        descriptionLabel.text = movie.overview
        ratingLabel.text = movie.voteAvarage
        genresLabel.text = movie.genres
        posterImageView.loadImage(imagePath: Constant.Server.imageURL + (movie.posterPath ?? ""))
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapImage))
        posterImageView.addGestureRecognizer(tap)
        movieTitleLabel.text = movie.title
        countryYearLabel.text = movie.productionCountriesAndYear
        playButton.isHidden = movie.videos.results.isEmpty
    }
    
    @objc private func didTapImage() {
        if let image = posterImageView.image {
            if image != Constant.Media.imagePlaceholder {
                let controller = LightboxController(images: [LightboxImage(image: image)])
                controller.modalPresentationStyle = .fullScreen
                LightboxConfig.PageIndicator.enabled = false
                present(controller, animated: true)
            }
        }
    }
}
