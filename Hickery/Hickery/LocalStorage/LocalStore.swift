//
//  LocalStore.swift
//  Hickery
//
//  Created by Florian Marcu on 11/29/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

class LocalStore: NSObject {

    private let hkDataStorage = HickeryDataStorage(userDefaults: UserDefaults.standard)

    func save(likes: [HickerySong], forUser: HickeryUser) {
        hkDataStorage.saveLikes(likes)
    }

    func likes(forUserId: String) -> [HickerySong]? {
        return hkDataStorage.likes()
    }
}
