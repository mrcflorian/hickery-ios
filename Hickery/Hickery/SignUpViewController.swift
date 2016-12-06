//
//  SignUpViewController.swift
//  Hickery
//
//  Created by Florian Marcu on 11/10/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import FacebookCore
import FacebookLogin
import UIKit

class SignUpViewController: UIViewController {


    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    let facebookAPIManager = FacebookAPIManager(accessToken: AccessToken.current!)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func startSignUpExperience(facebookUser: FacebookUser) {
        activityIndicator.startAnimating()
        self.facebookAPIManager.requestWallPosts(completion: { (posts: [FacebookPost]) in
            self.didSignUp(fbUser: facebookUser, fbPosts: posts)
        })
    }

    private func didSignUp(fbUser: FacebookUser, fbPosts: [FacebookPost]) {
        let hickerySongs = fbPosts
            .map{HickerySong(facebookPost: $0)}
            .filter{$0.youtubeVideoID() != ""}
        if (hickerySongs.count > 0) {
            LocalStore().save(likes: hickerySongs, forUser: HickeryUser(facebookUser: fbUser))
        }

        activityIndicator.stopAnimating()
        HickeryTabBarViewController.startLoggedInExperience(facebookUser: fbUser, controller: self)
    }
}
