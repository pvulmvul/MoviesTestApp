//
//  Router.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 24.10.2023.
//

import UIKit

protocol RouterProtocol {
    func showDetail(id: Int, title: String)
    func showAlert(view: UIViewController, title: String, description: String)
    func showAlertSheet(checkedAction: UIAlertAction?, view: UIViewController, title: String, description: String, completion: @escaping (_ action: UIAlertAction) -> Void)
    func showPlayer(view: UIViewController, id: String)
    func popToRoot()
    func dismissPresented(view: UIViewController)
}

final class Router: RouterProtocol {

    private let window: UIWindow
    private var navigationController: UINavigationController?
    private let assemblyBuilder: AssemblyBuilderProtocol?

    init(window: UIWindow, assemblyBuilder: AssemblyBuilderProtocol) {
        self.window = window
        self.assemblyBuilder = assemblyBuilder
        setupRoot()
    }
    
    func showDetail(id: Int, title: String) {
        guard let navigationController = navigationController else { return }
        guard let targetViewController = assemblyBuilder?.createDetailsModule(
            id: id,
            title: title,
            router: self
        ) else { return }
        targetViewController.title = title
        navigationController.pushViewController(targetViewController, animated: true)
    }
    
    func showPlayer(view: UIViewController, id: String) {
        guard let player = assemblyBuilder?.createVideoViewerModule(id: id, router: self) else { return }
        player.modalPresentationStyle = .fullScreen
        view.present(player, animated: true)
    }
    
    func showAlert(view: UIViewController, title: String, description: String) {
        guard let alert = assemblyBuilder?.createAlertController(
            title: title,
            description: description
        ) else { return }
        view.present(alert, animated: true, completion: nil)
    }
    
    func showAlertSheet(checkedAction: UIAlertAction?, view: UIViewController, title: String, description: String, completion: @escaping (_ action: UIAlertAction) -> Void) {
        guard let alert = assemblyBuilder?.createAlertSheet(
            checkedAction: checkedAction,
            title: title,
            description: description,
            completion: completion
        ) else { return}
        view.present(alert, animated: true)
    }
    
    func popToRoot() {
        guard let navigationController = navigationController else { return }
        navigationController.popToRootViewController(animated: true)
    }
    
    func dismissPresented(view: UIViewController) {
        view.dismiss(animated: true)
    }
}

private extension Router {

    func setupRoot() {
        navigationController = makeRootViewController()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func makeRootViewController() -> UINavigationController? {
        guard
            let homeViewController = assemblyBuilder?.createHomeModule(router: self)
        else {
            return nil
        }

        return UINavigationController(
            rootViewController: homeViewController
        )
    }
}
