//
//  MovieTableViewCell.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 24.10.2023.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!

    @IBOutlet private weak var substrateView: UIView!
    
    static var id: String {
        String(describing: self)
    }

    static var nib: UINib {
        UINib(nibName: id, bundle: nil)
    }

    func setupUI(model: MovieViewModel) {
        ratingLabel.text = model.voteAverage
        substrateView.backgroundColor = .black.withAlphaComponent(0.2)
        titleLabel.text = model.title + model.year
        genresLabel.text = model.genres
        posterImageView.loadImage(imagePath: Constant.Server.imageURL + (model.posterPath ?? ""))
    }
}
