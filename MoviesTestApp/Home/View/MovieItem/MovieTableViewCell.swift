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
        ratingLabel.text = "Rating".localized() + ": " + String(model.voteAverage)
        substrateView.backgroundColor = .black.withAlphaComponent(0.2)
        titleLabel.text = "\(model.title), \(year(string: model.releaseDate))"
        genresLabel.text = String(model.genres.joined(separator: ", "))
        posterImageView.loadImage(imagePath: Constant.Server.imageURL + (model.posterPath ?? ""))
    }
    
    func year(string: String) -> String {
        DateFormatter.dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = DateFormatter.dateFormatter.date(from: string) else { return "" }
        DateFormatter.dateFormatter.dateFormat = "yyyy"
        let year = DateFormatter.dateFormatter.string(from: date)
        return year
    }
}
