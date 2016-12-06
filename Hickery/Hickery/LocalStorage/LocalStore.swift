//
//  LocalStore.swift
//  Hickery
//
//  Created by Florian Marcu on 11/29/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

class LocalStore: NSObject {

    static var likes: [HickerySong]?

    func save(likes: [HickerySong], forUser: HickeryUser) {
        LocalStore.likes = likes
    }

    func likes(forUserId: String) -> [HickerySong]? {
        return LocalStore.likes
    }
}
