//
//  ViewViewerPresenter.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 28.10.2023.
//

import UIKit

protocol VideoViewerViewProtocol: NSObjectProtocol {
    func setupPlayer(id: String)
}

protocol VideoViewerPresenterProtocol {
    func loadTrailer()
    func closePlayer()
}

class VideoViewerPresenter: VideoViewerPresenterProtocol {
    weak var view: VideoViewerViewProtocol?
    
    var trailerID: String
    var router: RouterProtocol
    
    init(view: VideoViewerViewProtocol, trailerID: String, router: RouterProtocol) {
        self.view = view
        self.trailerID = trailerID
        self.router = router
    }
    
    func loadTrailer() {
        guard let view = self.view else {
            return
        }
        view.setupPlayer(id: trailerID)
    }
    
    func closePlayer() {
        guard let view = self.view as? UIViewController else { return }
        router.dismissPresented(view: view)
    }
}
