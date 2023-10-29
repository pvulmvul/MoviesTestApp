//
//  VideoViewerViewController.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 28.10.2023.
//

import UIKit
import youtube_ios_player_helper

final class VideoViewerViewController: UIViewController {

    @IBOutlet private weak var playerView: YTPlayerView!
    @IBOutlet private weak var closeButton: UIButton!
    
    var presenter: VideoViewerPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.delegate = self
        presenter?.loadTrailer()
    }
    
    @IBAction private func closeButtonPressed(_ sender: Any) {
        presenter?.closePlayer()
    }
}

extension VideoViewerViewController: VideoViewerViewProtocol {
    func setupPlayer(id: String) {
        playerView.load(withVideoId: id)
    }
}

extension VideoViewerViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.isHidden = false
        playerView.playVideo()
    }
}
