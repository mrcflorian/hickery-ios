//
//  PlaylistViewController.swift
//  Hickery
//
//  Created by Florian Marcu on 11/1/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import MediaPlayer
import UIKit

let kNumberOfSongsToEnqueueForBackground = 10

class PlaylistViewController: UIViewController {

    @IBOutlet var likeButton: UIButton!

    static var playingPlaylistVC: PlaylistViewController?

    var playerVC: PlayerViewController?
    var songTableVC: SongTableViewController?
    var songs: [HickerySong] = [] {
        didSet {
            updateIfNeeded()
        }
    }
    var user: HickeryUser? {
        didSet {
            if let user = user {
                likeStore = LikeStore(user: user)
            }
        }
    }

    var currentPlayingIndex: Int = 0

    let commandCenter = MPRemoteCommandCenter.shared()
    private var likeStore: LikeStore?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateIfNeeded()
        configureMediaPlayerCommandCenter()
    }

    func playSongInForeground(hickerySong: HickerySong) {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle: hickerySong.title!]
        currentPlayingIndex = index(of: hickerySong)
        playerVC?.playSongInForeground(atIndex: currentPlayingIndex)
        songTableVC?.scrollToSongIndex(index: currentPlayingIndex)
        updateActionBar()
    }

    func playNextSong(inBackground: Bool) {
        if currentPlayingIndex + 1 < songs.count {
            currentPlayingIndex += 1
            if (inBackground) {
                //playerVC?.playNextSongInBackground()
                self.playSongInForeground(hickerySong: songs[currentPlayingIndex])
            } else {
                self.playSongInForeground(hickerySong: songs[currentPlayingIndex])
            }
        }
    }

    func updateIfNeeded() {
        configureViewControllers()
        playerVC?.delegate = self
        playerVC?.update(videoIds: self.videoIds())

        songTableVC?.songTableViewControllerDelegate = self
        songTableVC?.songs = songs
    }

    private func playPreviousSong() {
        // always in background
        if currentPlayingIndex - 1 >= 0 {
            currentPlayingIndex -= 1
            playerVC?.playPreviousSongInBackground()
        }
    }

    private func configureViewControllers() {
        if (playerVC != nil && songTableVC != nil) {
            return
        }
        playerVC = childViewControllers.first as? PlayerViewController
        songTableVC = childViewControllers.last as? SongTableViewController
    }

    internal func videoIds() -> [String]? {
        var ids = [String]()
        for song in songs {
            ids.append(song.youtubeVideoID())
        }
        return ids
    }

    private func index(of hickerySong: HickerySong) -> Int {
        for (index, song) in songs.enumerated() {
            if (song.songID == hickerySong.songID) {
                return index
            }
        }
        return 0
    }

    private func configureMediaPlayerCommandCenter()
    {
        //UIApplication.shared.beginReceivingRemoteControlEvents()
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget(self, action:#selector(nextTrackCommandSelector))
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget(self, action:#selector(previousTrackCommandSelector))
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget(self, action:#selector(playTrackCommandSelector))
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget(self, action:#selector(pauseTrackCommandSelector))
        commandCenter.skipForwardCommand.isEnabled = false
        commandCenter.skipBackwardCommand.isEnabled = false
            
    }
    
    func playTrackCommandSelector() {
        print("play track selector")
        VLCPlayer.instance.play()
    }
    
    
    func pauseTrackCommandSelector() {
        print("pause track selector")
        VLCPlayer.instance.pause()
    }
    
    func nextTrackCommandSelector() {
        print("next track selector")
        //if (self == PlaylistViewController.playingPlaylistVC) {
            self.playNextSong(inBackground: true)
        //}
    }

    func previousTrackCommandSelector() {
        //if (self == PlaylistViewController.playingPlaylistVC) {
            self.playPreviousSong()
        //}
    }

    @IBAction func didTapLikeButton(_ sender: UIButton) {
        if let song = currentPlayingSong() {
            likeStore?.toggle(song: song)
            updateActionBar()
        }
    }

    private func updateActionBar() {
        guard let likeStore = likeStore, let song = currentPlayingSong() else {
            return
        }
        let likeImageName = (likeStore.likes(song: song)) ? #imageLiteral(resourceName: "heart-filled") : #imageLiteral(resourceName: "heart-empty")
        likeButton.setImage(likeImageName, for: .normal)
    }

    private func currentPlayingSong() -> HickerySong? {
        if currentPlayingIndex < songs.count {
            return songs[currentPlayingIndex];
        }
        return nil
    }
}

extension PlaylistViewController: SongTableViewControllerDelegate {
    func songTableViewController(_ songTableViewController: SongTableViewController, didSelectHickerySong hickerySong: HickerySong) {
        self.playSongInForeground(hickerySong: hickerySong)
    }
}

extension PlaylistViewController: PlayerViewControllerDelegate {
    func playerViewControllerDidFinishCurrentSong(_ playerViewController: PlayerViewController) {
        self.playNextSong(inBackground: false)
    }

    func playerViewControllerDidStartPlaying(_ playerViewController: PlayerViewController) {
        if (self != PlaylistViewController.playingPlaylistVC) {
            
            //PlaylistViewController.playingPlaylistVC?.playerVC?.youtubePlayerView.stopVideo()
        }
        PlaylistViewController.playingPlaylistVC = self
    }

    func playerViewControllerDidSwitchToBackground(_ playerViewController: PlayerViewController) {
        //playerViewController.youtubePlayerView.playVideo()
    }
}
