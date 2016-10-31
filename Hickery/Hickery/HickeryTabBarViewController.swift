//
//  HickeryTabBarViewController.swift
//  Hickery
//
//  Created by Florian Marcu on 10/30/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit

class HickeryTabBarViewController: UITabBarController {

    let apiManager = APIManager()

    var userId = "" {
        didSet {
            requestUserLikes()
        }
    }

    private func requestUserLikes() {
        apiManager.requestLikes(userId: userId) { (songs) in
            print(songs)
        }
    }

    private func didFetchUserSongs() {
    }

    private func didFetchUserProfile() {

    }
}
