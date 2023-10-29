//
//  ViewViewerPresenter.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 28.10.2023.
//

import Foundation

protocol VideoViewerViewProtocol: AnyObject {
    func setupPlayer(id: String)
}

protocol VideoViewerPresenterProtocol {
    func loadTrailer()
    func closePlayer()
}

final class VideoViewerPresenter: VideoViewerPresenterProtocol {
    private weak var view: VideoViewerViewProtocol?
    
    private var trailerID: String
    private var router: RouterProtocol
    
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
        router.dismissPresented()
    }
}
