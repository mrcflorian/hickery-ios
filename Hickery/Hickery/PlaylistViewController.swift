//
//  PlaylistViewController.swift
//  Hickery
//
//  Created by Florian Marcu on 11/1/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import MediaPlayer
import UIKit

class PlaylistViewController: UIViewController {

    static var playingPlaylistVC: PlaylistViewController?

    var playerVC: PlayerViewController?
    var songTableVC: SongTableViewController?

    var autoplayEnabled: Bool = true
    var songs: [HickerySong] = [] {
        didSet {
            updateIfNeeded()
        }
    }
    var currentPlayingIndex: Int32 = -1

    let commandCenter = MPRemoteCommandCenter.shared()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateIfNeeded()
        configureMediaPlayerCommandCenter()
    }

    func play(hickerySong: HickerySong, inBackground: Bool) {
        PlaylistViewController.playingPlaylistVC = self
        currentPlayingIndex = index(of: hickerySong)
        playerVC?.playSong(atIndex: currentPlayingIndex)
        if (inBackground == false) {
            songTableVC?.scrollToSongIndex(index: Int(currentPlayingIndex))
        }
    }

    func playNextSong(inBackground: Bool) {
        if currentPlayingIndex + 1 < Int32(songs.count) {
            currentPlayingIndex += 1
            self.play(hickerySong: songs[Int(currentPlayingIndex)], inBackground: inBackground)
        }
    }

    func updateIfNeeded() {
        configureViewControllers()
        if (songs.count > 0) {
            playerVC?.delegate = self
            playerVC?.update(videoIds: self.videoIds())
            songTableVC?.songTableViewControllerDelegate = self
            songTableVC?.songs = songs
            if (autoplayEnabled) {
                playNextSong(inBackground: false)
            }
        }
    }

    private func configureViewControllers() {
        if (playerVC != nil && songTableVC != nil) {
            return
        }
        playerVC = childViewControllers.first as? PlayerViewController
        songTableVC = childViewControllers.last as? SongTableViewController
    }

    private func videoIds() -> [String]? {
        var ids = [String]()
        for song in songs {
            ids.append(song.youtubeVideoID())
        }
        return ids
    }

    private func index(of hickerySong: HickerySong) -> Int32 {
        for (index, song) in songs.enumerated() {
            if (song.songID == hickerySong.songID) {
                return Int32(index)
            }
        }
        return 0
    }

    private func configureMediaPlayerCommandCenter()
    {
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget(self, action:#selector(nextTrackCommandSelector))
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget(self, action:#selector(previousTrackCommandSelector))
    }

    func nextTrackCommandSelector() {
        if (self == PlaylistViewController.playingPlaylistVC) {
            self.playNextSong(inBackground: true)
        }
    }

    func previousTrackCommandSelector() {
        if (self == PlaylistViewController.playingPlaylistVC) {

        }
    }
}

extension PlaylistViewController: SongTableViewControllerDelegate {
    func songTableViewController(_ songTableViewController: SongTableViewController, didSelectHickerySong hickerySong: HickerySong) {
        self.play(hickerySong: hickerySong, inBackground: false)
    }
}

extension PlaylistViewController: PlayerViewControllerDelegate {
    func playerViewControllerDidFinishCurrentSong(_ playerViewController: PlayerViewController) {
        self.playNextSong(inBackground: false)
    }
}
