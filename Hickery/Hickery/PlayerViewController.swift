//
//  PlayerViewController.swift
//  Hickery
//
//  Created by Florian Marcu on 11/1/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

let kMaxSongCountPerPlaylist = 100

protocol PlayerViewControllerDelegate {
    func playerViewControllerDidFinishCurrentSong(_ playerViewController: PlayerViewController)
    func playerViewControllerDidStartPlaying(_ playerViewController: PlayerViewController)
}

class PlayerViewController: UIViewController {

    @IBOutlet var youtubePlayerView: YTPlayerView!
    var delegate: PlayerViewControllerDelegate?
    var autoplayEnabled: Bool = false
    var didForcePlayingAfterBackgrounding = false
    var videoIds: [String]?

    let playerVars = ["origin":"http://www.youtube.com", "playsinline":1, "modestbranding":1, "showinfo":1, "autohide":1, "controls":1] as [String : Any]

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePlayer()
    }

    func update(videoIds: [String]?) {
        guard let videoIds = videoIds else {
            return
        }
        self.videoIds = slice(array: videoIds, count: kMaxSongCountPerPlaylist)

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

    private func slice(array: [String], count: Int) -> [String] {
        if array.count < count {
            return array
        }
        var res = [String]()
        for i in 0 ..< count {
            res.append(array[i])
        }
        return res
    }
}

// MARK: YTPlayerViewDelegate
extension PlayerViewController: YTPlayerViewDelegate {

    public func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .ended {
            self.delegate?.playerViewControllerDidFinishCurrentSong(self)
        } else if state == .playing {
            self.delegate?.playerViewControllerDidStartPlaying(self)
        } else if state == .paused {
            if (UIApplication.shared.applicationState == .background) {
                if (!didForcePlayingAfterBackgrounding) {
                    playerView.playVideo()
                    didForcePlayingAfterBackgrounding = true
                }
            } else {
                didForcePlayingAfterBackgrounding = false
            }
        }
    }

    public func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        if (autoplayEnabled) {
            playerView.playVideo()
        }
    }
}
