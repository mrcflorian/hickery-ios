//
//  PlaylistViewController.swift
//  Hickery
//
//  Created by Florian Marcu on 11/1/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController {

    var playerVC: PlayerViewController?
    var songTableVC: SongTableViewController?

    func play(hickerySong: HickerySong) {
        playerVC?.videoId = hickerySong.youtubeVideoID()
    }

    func playNextSong() {
        if let hickerySong = songTableVC?.getNextSongForPlaying() {
            self.play(hickerySong: hickerySong)
        }
    }

    func update(songs: [HickerySong]) {
        configureViewControllers()
        playerVC?.delegate = self
        songTableVC?.songTableViewControllerDelegate = self
        songTableVC?.songs = songs
        playNextSong()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }

    private func configureViewControllers() {
        if (playerVC != nil && songTableVC != nil) {
            return
        }
        playerVC = childViewControllers.first as? PlayerViewController
        songTableVC = childViewControllers.last as? SongTableViewController
    }
}

extension PlaylistViewController: SongTableViewControllerDelegate {
    func songTableViewController(_ songTableViewController: SongTableViewController, didSelectHickerySong hickerySong: HickerySong) {
        self.play(hickerySong: hickerySong)
    }
}

extension PlaylistViewController: PlayerViewControllerDelegate {
    func playerViewControllerDidFinishCurrentSong(_ playerViewController: PlayerViewController) {
        self.playNextSong()
    }
}
