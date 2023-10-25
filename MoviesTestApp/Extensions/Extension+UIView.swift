//
//  Extension+UIVIew.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 25.10.2023.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(imagePath: String) {
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: URL(string: imagePath),
            placeholder: UIImage(named: "noImagePlaceholder"),
            options: [
                .processor(DownsamplingImageProcessor(size: self.frame.size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
    }
}
