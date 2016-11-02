//
//  PlayerViewController.swift
//  Hickery
//
//  Created by Florian Marcu on 11/1/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class PlayerViewController: UIViewController, YTPlayerViewDelegate {

    @IBOutlet var youtubePlayerView: YTPlayerView!
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
        youtubePlayerView.load(withVideoId: videoId)
        youtubePlayerView.playVideo()
    }
}
