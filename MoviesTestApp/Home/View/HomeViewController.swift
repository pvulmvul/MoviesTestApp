//
//  ViewController.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 23.10.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    let api: MoviesAPIProtocol = MoviesAPI()
    override func viewDidLoad() {
        super.viewDidLoad()
        api.getGenres { genres, error in
            print(genres)
        }
    }
    
    
}

