//
//  HomeViewController.swift
//  Hickery
//
//  Created by Florian Marcu on 11/6/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let apiManager = APIManager()
    let playlistVC = StoryboardEntityProvider().playlistViewController()

    var user: HickeryUser? {
        didSet {
            playlistVC.user = user
            requestUserLikes()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(playlistVC.view)
    }

    private func requestUserLikes() {
        guard let user = user else {
            return
        }
        apiManager.requestLikes(user: user) { (songs) in
            self.didFetchUserSongs(songs: songs)
        }
    }

    private func didFetchUserSongs(songs: [HickerySong]) {
        playlistVC.songs = songs
        let currSong = songs[0]
//        let videoId: String = currSong.youtubeVideoID()
//        let apiManager = APIManager()
//        apiManager.requestAudioURL(videoId: videoId) { (audioURL) in
//            print("Audio: " + audioURL)
//        }

        
    }
}
