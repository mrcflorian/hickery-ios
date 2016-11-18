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

    var videoIds: [String]?

    let playerVars = ["origin":"http://www.youtube.com", "playsinline":1, "modestbranding":1, "showinfo":1, "autohide":1, "controls":1] as [String : Any]

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePlayer()
    }

    func update(videoIds: [String]?) {
        self.videoIds = videoIds
        guard let videoIds = videoIds else {
            return
        }
        var playerVars = self.playerVars
        playerVars["playlist"] = self.playlistString()
        youtubePlayerView.load(withVideoId: videoIds[0], playerVars: playerVars)
    }

    func playSong(atIndex index: Int32) {
        youtubePlayerView.playVideo(at: index + 1)
    }

    private func configurePlayer() {
        youtubePlayerView.delegate = self
        youtubePlayerView.webView?.mediaPlaybackAllowsAirPlay = true
    }

    private func playlistString() -> String? {
        return videoIds?.joined(separator: ",")
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
