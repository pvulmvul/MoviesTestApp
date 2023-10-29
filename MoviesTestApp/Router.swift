//
//  Router.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 24.10.2023.
//

import UIKit

protocol RouterProtocol {
    func showDetail(id: Int, title: String)
    func showAlert(title: String, description: String)
    func showAlertSheet(checkedAction: AlertAction, title: String, description: String, completion: @escaping (_ action: AlertAction) -> Void)
    func showPlayer(id: String)
    func popToRoot()
    func dismissPresented()
}

final class Router: RouterProtocol {

    private let window: UIWindow
    private var navigationController: UINavigationController?
    private let assemblyBuilder: AssemblyBuilderProtocol

    init(window: UIWindow, assemblyBuilder: AssemblyBuilderProtocol) {
        self.window = window
        self.assemblyBuilder = assemblyBuilder
        setupRoot()
    }
    
    func showDetail(id: Int, title: String) {
        guard let navigationController = navigationController else { return }
        let targetViewController = assemblyBuilder.createDetailsModule(
            id: id,
            router: self
        )
        targetViewController.title = title
        navigationController.pushViewController(targetViewController, animated: true)
    }
    
    func showPlayer(id: String) {
        guard let navigationController = navigationController else { return }
        let player = assemblyBuilder.createVideoViewerModule(id: id, router: self)
        navigationController.present(player, animated: true)
    }
    
    func showAlert(title: String, description: String) {
        guard let navigationController = navigationController else { return }
        let alert = assemblyBuilder.createAlertController(
            title: title,
            description: description
        )
        navigationController.present(alert, animated: true, completion: nil)
    }
    
    func showAlertSheet(checkedAction: AlertAction, title: String, description: String, completion: @escaping (_ action: AlertAction) -> Void) {
        guard let navigationController = navigationController else { return }
        let alert = assemblyBuilder.createAlertSheet(
            checkedAction: checkedAction,
            title: title,
            description: description,
            completion: completion
        )
        navigationController.present(alert, animated: true)
    }
    
    func popToRoot() {
        guard let navigationController = navigationController else { return }
        navigationController.popToRootViewController(animated: true)
    }
    
    func dismissPresented() {
        guard let navigationController = navigationController else { return }
        navigationController.dismiss(animated: true)
    }
}

private extension Router {

    func setupRoot() {
        navigationController = makeRootViewController()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func makeRootViewController() -> UINavigationController? {
        let homeViewController = assemblyBuilder.createHomeModule(router: self)

        return UINavigationController(
            rootViewController: homeViewController
        )
    }
}
