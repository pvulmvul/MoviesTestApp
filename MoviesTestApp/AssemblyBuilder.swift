//
//  AssemblyBuilder.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 24.10.2023.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createHomeModule(router: RouterProtocol) -> UIViewController
    func createDetailsModule(id: Int, title: String, router: RouterProtocol) -> UIViewController
    func createAlertController(title: String, description: String) -> UIAlertController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    func createAlertController(title: String, description: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
    
    func createHomeModule(router: RouterProtocol) -> UIViewController {
        let view = HomeViewController()
        let networkService = MoviesAPI()
        let presenter = HomePresenter(view: view, networkService: networkService, router: router)
        view.homePresenter = presenter
        return view
    }
    
    func createDetailsModule(id: Int, title: String, router: RouterProtocol) -> UIViewController {
        let view = DetailsViewController()
        let networkService = MoviesAPI()
        let presenter = DetailsPresenter(movieId: id, view: view, networkService: networkService, router: router)
        view.detailsPresenter = presenter
        return view
    }
}
