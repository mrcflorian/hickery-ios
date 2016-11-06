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

    var userId: String? {
        didSet {
            requestUserLikes()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(playlistVC.view)
    }

    private func requestUserLikes() {
        guard let userId = userId else {
            return
        }
        apiManager.requestLikes(userId: userId) { (songs) in
            self.didFetchUserSongs(songs: songs)
        }
    }

    private func didFetchUserSongs(songs: [HickerySong]) {
        playlistVC.update(songs: songs)
    }
}
