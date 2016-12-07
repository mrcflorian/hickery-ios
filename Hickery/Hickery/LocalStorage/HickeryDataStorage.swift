//
//  HickeryDataStorage.swift
//  Hickery
//
//  Created by Florian Marcu on 12/5/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

class HickeryDataStorage {

    private let kHickeryDataStorageLikesKey = "kHickeryDataStorageLikesKey"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func saveLikes(_ likes: [HickerySong]) {
        userDefaults.set(self.archivedSongs(songs: likes), forKey: kHickeryDataStorageLikesKey)
    }

    func likes() -> [HickerySong]? {
        if let likes = self.unarchiveSongs(data: userDefaults.object(forKey: kHickeryDataStorageLikesKey) as? Data) {
            return likes
        }
        return nil
    }

    func removeLikes() {
        userDefaults.removeObject(forKey: kHickeryDataStorageLikesKey)
    }

    // MARK - Private

    private func archivedSongs(songs: [HickerySong]) -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: songs)
    }

    private func unarchiveSongs(data: Data?) -> [HickerySong]? {
        if let data = data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [HickerySong]
        }
        return nil
    }
}
