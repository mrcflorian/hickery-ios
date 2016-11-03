//
//  PlayerViewController.swift
//  Hickery
//
//  Created by Florian Marcu on 11/1/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

protocol PlayerViewControllerDelegate {
    func playerViewControllerDidFinishCurrentSong(_ playerViewController: PlayerViewController)
}

class PlayerViewController: UIViewController {

    @IBOutlet var youtubePlayerView: YTPlayerView!
    var delegate: PlayerViewControllerDelegate?

    var videoId: String? {
        didSet {
            videoDidChange()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePlayer()
    }

    private func configurePlayer() {
        youtubePlayerView.delegate = self
    }

    private func videoDidChange() {
        guard let videoId = videoId else {
            return
        }
        youtubePlayerView.load(withVideoId: videoId, playerVars: ["origin":"http://www.youtube.com", "playsinline":1])
    }
}

// MARK: YTPlayerViewDelegate
extension PlayerViewController: YTPlayerViewDelegate {
    public func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .ended {
            self.delegate?.playerViewControllerDidFinishCurrentSong(self)
        }
    }

    public func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        youtubePlayerView.playVideo()
    }
}
