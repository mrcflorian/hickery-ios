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
    let apiManager = APIManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func startSignUpExperience(facebookUser: FacebookUser) {
        activityIndicator.startAnimating()
        apiManager.signUpUser(facebookUser: facebookUser) { (hickeryUser) in
            self.facebookAPIManager.requestWallPosts(completion: { (posts: [FacebookPost]) in
                self.sendPostsToHickery(hickeryUser: hickeryUser, facebookUser: facebookUser, fbPosts: posts)
            })
        }
    }

    private func sendPostsToHickery(hickeryUser: HickeryUser, facebookUser: FacebookUser, fbPosts: [FacebookPost]) {
        let hickerySongs = fbPosts
            .map{HickerySong(facebookPost: $0)}
            .filter{$0.youtubeVideoID() != ""}
        if (hickerySongs.count > 0) {
            self.apiManager.uploadLikes(hickeryUser: hickeryUser, likes: hickerySongs, completion: { () in
                self.didFinishSignUpProcess(facebookUser: facebookUser)
            })
        } else {
            self.didFinishSignUpProcess(facebookUser: facebookUser)
        }
    }

    private func didFinishSignUpProcess(facebookUser: FacebookUser) {
        HickeryTabBarViewController.startLoggedInExperience(facebookUser: facebookUser, controller: self)
    }
}
