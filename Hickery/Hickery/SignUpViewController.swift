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
    let localStore = LocalStore()
    let apiManager = APIManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func startSignUpExperience(facebookUser: FacebookUser) {
        activityIndicator.startAnimating()
        apiManager.signUpUser(facebookUser: facebookUser) { (hickeryUser) in
            if (self.localStore.likes(forUserId: "TODO:") != nil) {
                // We already fetched the wall posts, but the sign up was interrupted
                self.didFinishSignUpProcess(facebookUser: facebookUser)
            } else {
                self.facebookAPIManager.requestWallPosts(completion: { (posts: [FacebookPost]) in
                    self.savePostsToLocalStore(fbUser: facebookUser, fbPosts: posts)
                    self.didFinishSignUpProcess(facebookUser: facebookUser)
                })
            }
        }
    }

    private func savePostsToLocalStore(fbUser: FacebookUser, fbPosts: [FacebookPost]) {
        let hickerySongs = fbPosts
            .map{HickerySong(facebookPost: $0)}
            .filter{$0.youtubeVideoID() != ""}
        if (hickerySongs.count > 0) {
            LocalStore().save(likes: hickerySongs, forUser: HickeryUser(facebookUser: fbUser))
        }
    }

    private func didFinishSignUpProcess(facebookUser: FacebookUser) {
        HickeryTabBarViewController.startLoggedInExperience(facebookUser: facebookUser, controller: self)
    }
}
