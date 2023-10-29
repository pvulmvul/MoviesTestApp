//
//  AssemblyBuilder.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 24.10.2023.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createHomeModule(router: RouterProtocol) -> UIViewController
    func createDetailsModule(id: Int, router: RouterProtocol) -> UIViewController
    func createVideoViewerModule(id: String, router: RouterProtocol) -> UIViewController
    func createAlertController(title: String, description: String) -> UIAlertController
    func createAlertSheet(checkedAction: AlertAction, title: String, description: String, completion: @escaping (_ action: AlertAction) -> Void) -> UIAlertController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    
    private var networkService: MoviesAPIProtocol
    
    init(networkService: MoviesAPIProtocol) {
        self.networkService = networkService
    }
    
    func createVideoViewerModule(id: String, router: RouterProtocol) -> UIViewController {
        let view = VideoViewerViewController()
        view.modalPresentationStyle = .fullScreen
        view.presenter = VideoViewerPresenter(view: view, trailerID: id, router: router)
        return view
    }
    
    func createAlertController(title: String, description: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
    
    func createAlertSheet(checkedAction: AlertAction, title: String, description: String, completion: @escaping (_ action: AlertAction) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .actionSheet)
        let actionAsc = UIAlertAction(title: "Ascending".localized(), style: .default) { action in
            completion(.ascending)
        }
        
        let actionDesc = UIAlertAction(title: "Descending".localized(), style: .default) { action in
            completion(.descending)
        }
        
        let actionClose = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(actionAsc)
        alert.addAction(actionDesc)
        alert.addAction(actionClose)
        
        switch checkedAction {
        case .ascending: actionAsc.setValue(true, forKey: "checked")
        case .descending: actionDesc.setValue(true, forKey: "checked")
        }
        return alert
    }
    
    func createHomeModule(router: RouterProtocol) -> UIViewController {
        let view = HomeViewController()
        let presenter = HomePresenter(view: view, networkService: networkService, router: router)
        view.homePresenter = presenter
        return view
    }
    
    func createDetailsModule(id: Int, router: RouterProtocol) -> UIViewController {
        let view = DetailsViewController()
        let presenter = DetailsPresenter(movieId: id, view: view, networkService: networkService, router: router)
        view.detailsPresenter = presenter
        return view
    }
}
