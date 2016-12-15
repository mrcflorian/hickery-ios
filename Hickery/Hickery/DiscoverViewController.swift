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

    var user: HickeryUser? {
        didSet {
            playlistVC.user = user
            requestUserRecommendations()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(playlistVC.view)
    }

    private func requestUserRecommendations() {
        guard let userId = user?.userID else {
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
