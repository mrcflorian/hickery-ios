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

    private let apiManager = APIManager()
    private let facebookSyncManager = FacebookSyncManager(facebookAPIManager: FacebookAPIManager(accessToken: AccessToken.current!), apiManager: APIManager())

    func startSignUpExperience(facebookUser: FacebookUser) {
        activityIndicator.startAnimating()
        apiManager.signUpUser(facebookUser: facebookUser) { (hickeryUser) in
            self.facebookSyncManager.syncFacebookWallPosts(hickeryUser: hickeryUser, completionBlock: { (hickerySongs) in
                self.didFinishSignUpProcess(facebookUser: facebookUser)
            })
        }
    }

    private func didFinishSignUpProcess(facebookUser: FacebookUser) {
        HickeryTabBarViewController.startLoggedInExperience(facebookUser: facebookUser, controller: self)
    }
}
