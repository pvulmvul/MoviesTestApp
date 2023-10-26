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
    func createAlertSheet(checkedAction: UIAlertAction?, title: String, description: String, completion: @escaping (_ action: UIAlertAction) -> Void) -> UIAlertController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    func createAlertController(title: String, description: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
    
    func createAlertSheet(checkedAction: UIAlertAction?, title: String, description: String, completion: @escaping (_ action: UIAlertAction) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .actionSheet)
        let actionAsc = UIAlertAction(title: "Ascending".localized(), style: .default) { action in
            completion(action)
        }
        
        let actionDesc = UIAlertAction(title: "Descending".localized(), style: .default) { action in
            completion(action)
        }
        
        let actionClose = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(actionAsc)
        alert.addAction(actionDesc)
        alert.addAction(actionClose)
        
        if let checkedAction = checkedAction {
            switch checkedAction.title {
                case "Ascending".localized(): actionAsc.setValue(true, forKey: "checked")
                case "Descending".localized(): actionDesc.setValue(true, forKey: "checked")
                default: return alert
            }
        }
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
