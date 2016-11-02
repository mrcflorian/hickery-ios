//
//  PlaylistViewController.swift
//  Hickery
//
//  Created by Florian Marcu on 11/1/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController {

    let apiManager = APIManager()

    var playerVC: PlayerViewController?
    var songTableVC: SongTableViewController?

    var userId: String? {
        didSet {
            requestUserLikes()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }

    private func requestUserLikes() {
        guard let userId = userId else {
            return
        }
        apiManager.requestLikes(userId: userId) { (songs) in
            self.didFetchUserSongs(songs: songs)
        }
    }

    private func configureViewControllers() {
        if (playerVC != nil && songTableVC != nil) {
            return
        }
        playerVC = childViewControllers.first as? PlayerViewController
        songTableVC = childViewControllers.last as? SongTableViewController
    }

    private func didFetchUserSongs(songs: [HickerySong]) {
        configureViewControllers()
        playerVC?.videoId = songs.first?.youtubeVideoID()
    }

    private func didFetchUserProfile() {

    }
}
