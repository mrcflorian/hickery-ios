//
//  LikeStore.swift
//  Hickery
//
//  Created by Florian Marcu on 12/15/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

// In memory data store tracking whether the current user likes or dislikes a song

class LikeStore {

    private static var dictionary: [String: Bool] = [:]

    private let apiManager = APIManager()
    private let user: HickeryUser

    init(user: HickeryUser) {
        self.user = user
    }

    func likes(song: HickerySong) -> Bool {
        guard let id = song.songID else {
            return false
        }
        if let result = LikeStore.dictionary[id] {
            return result
        }
        return false
    }

    func toggle(song: HickerySong) {
        guard let id = song.songID else {
            return
        }
        let liked = self.likes(song: song)
        LikeStore.dictionary[id] = !liked
        sendLikeActionToHickery(song: song)
    }

    func insert(songs: [HickerySong], liked: Bool) {
        songs.forEach { (song) in
            guard let id = song.songID else {
                return
            }
            LikeStore.dictionary[id] = liked
        }
    }

    private func sendLikeActionToHickery(song: HickerySong) {
        apiManager.like(hickeryUser: user, hickerySong: song, isDislike: !self.likes(song: song))
    }
}
