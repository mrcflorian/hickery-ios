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

    let facebookAPIManager = FacebookAPIManager(accessToken: AccessToken.current!)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func signUpFacebookUser() {
        facebookAPIManager.requestFacebookUser { (fbUser: FacebookUser) in
            print (fbUser)
        }
        facebookAPIManager.requestWallPosts(completion: { (posts: [FacebookPost]) in
            print (posts)
        })
        facebookAPIManager.requestFacebookUserPageLikes()
    }
}
