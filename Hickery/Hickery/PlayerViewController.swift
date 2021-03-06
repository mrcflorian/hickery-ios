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
    func playerViewControllerDidStartPlaying(_ playerViewController: PlayerViewController)
    func playerViewControllerDidSwitchToBackground(_ playerViewController: PlayerViewController)
}

class PlayerViewController: UIViewController {

    @IBOutlet var youtubePlayerView: YTPlayerView!
    var delegate: PlayerViewControllerDelegate?
    var didForcePlayingAfterBackgrounding = false
    var videoIds: [String]?

    internal var didStartPlaybackAfterQueing = false

    let playerVars = ["origin":"http://www.youtube.com", "playsinline":1, "modestbranding":1, "autohide":1, "controls":1] as [String : Any]

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePlayer()
    }

    func update(videoIds: [String]?) {
        guard let videoIds = videoIds else {
            return
        }
        self.videoIds = videoIds

        if (videoIds.count >= 1) {
            youtubePlayerView.load(withVideoId: videoIds[0], playerVars: playerVars)
        }
    }

    func playSongInForeground(atIndex index: Int) {
        if let videoIds = videoIds, index < videoIds.count {
            didStartPlaybackAfterQueing = false
            youtubePlayerView.cuePlaylist(byVideos: videosToBeEnqueued(index: index), index: 0, startSeconds: 0, suggestedQuality: .small)
        }
    }

    func playNextSongInBackground() {
        youtubePlayerView.nextVideo()
    }

    func playPreviousSongInBackground() {
        youtubePlayerView.previousVideo()
    }

    private func videosToBeEnqueued(index: Int) -> [String] {
        if let videoIds = videoIds, index < videoIds.count {
            let stopIndex = min(index + kNumberOfSongsToEnqueueForBackground, videoIds.count - 1)
            return Array(videoIds[index...stopIndex])
        }
        return []
    }

    private func configurePlayer() {
        youtubePlayerView.delegate = self
        youtubePlayerView.webView?.mediaPlaybackAllowsAirPlay = true
    }
}

// MARK: YTPlayerViewDelegate
extension PlayerViewController: YTPlayerViewDelegate {

    public func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .ended {
            self.delegate?.playerViewControllerDidFinishCurrentSong(self)
        } else if state == .playing {
            didStartPlaybackAfterQueing = true
            self.delegate?.playerViewControllerDidStartPlaying(self)
        } else if state == .paused {
            if (UIApplication.shared.applicationState == .background) {
                if (!didForcePlayingAfterBackgrounding) {
                    self.delegate?.playerViewControllerDidSwitchToBackground(self)
                    didForcePlayingAfterBackgrounding = true
                }
            } else {
                didForcePlayingAfterBackgrounding = false
            }
        } else if state == .queued {
            if (!didStartPlaybackAfterQueing) {
                playerView.playVideo()
            }
        }
    }

    public func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
            /*
             * We enqueue the songs that will be played in background, in case the user
             * locks the screen. This is a workaround for Youtube SDK.
             */
//            if let videoIds = videoIds, lastPlayedIndex < videoIds.count {
//                let startIndex = max(0, lastPlayedIndex);
//                let stopIndex = min(startIndex + kNumberOfSongsEnqueueForBackground, videoIds.count - 1)
//                let videoIdsSubarray = Array(videoIds[startIndex...stopIndex])
//                youtubePlayerView.cuePlaylist(byVideos: videoIdsSubarray, index: 0, startSeconds: 0, suggestedQuality: .small)
//            }
    }
}
