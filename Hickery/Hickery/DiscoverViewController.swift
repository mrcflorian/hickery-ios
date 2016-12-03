//
//  DiscoverViewController.swift
//  Hickery
//
//  Created by Florian Marcu on 11/3/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    let apiManager = APIManager()
    let playlistVC = StoryboardEntityProvider().playlistViewController()

    var userId: String? {
        didSet {
            configurePlaylistVC()
            requestUserRecommendations()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePlaylistVC()
        self.view.addSubview(playlistVC.view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playlistVC.autoplayEnabled = true
    }

    private func configurePlaylistVC() {
        playlistVC.autoplayEnabled = false
    }

    private func requestUserRecommendations() {
        guard let userId = userId else {
            return
        }
        apiManager.requestRecommendations(userId: userId) { (songs) in
            self.didFetchUserSongs(songs: songs)
        }
    }

    private func didFetchUserSongs(songs: [HickerySong]) {
        playlistVC.songs = songs
    }
}
