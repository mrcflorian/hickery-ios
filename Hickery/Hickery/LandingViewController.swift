//
//  LandingViewController.swift
//  Hickery
//
//  Created by Florian Marcu on 10/30/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import FacebookCore
import FacebookLogin
import UIKit

class LandingViewController: UIViewController {

    @IBOutlet var loginButton: HKLoginButton!

    private let readPermissions: [ReadPermission] = [ .publicProfile, .email, .userFriends, .custom("user_posts") ]

    let apiManager = APIManager()

    override func viewDidAppear(_ animated: Bool) {
        if let _ = AccessToken.current {
            didLoginWithFacebook()
            return;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 10
    }

    private func didReceiveFacebookLoginResult(loginResult: LoginResult) {
        switch loginResult {
        case .success:
            didLoginWithFacebook()
        case .failed(let error):
            print (error)
        default:
            print ("cancelled")
        }
    }

    private func didLoginWithFacebook() {
        if let accessToken = AccessToken.current {
            let facebookAPIManager = FacebookAPIManager(accessToken: accessToken)
            facebookAPIManager.requestFacebookUser(completion: { (facebookUser) in
                if let email = facebookUser.email {
                    self.apiManager.requestUser(email: email, completion: { (hickeryUser) in
                        if (hickeryUser != nil) {
                            // already signed up
                            HickeryTabBarViewController.startLoggedInExperience(facebookUser: facebookUser, controller: self)
                        } else {
                            // new user, start sign up experience
                            let signUpVC = SignUpViewController()
                            signUpVC.startSignUpExperience(facebookUser: facebookUser)
                            self.present(signUpVC, animated: false, completion: nil)
                        }
                    })
                }
            })
        }
    }
    
    @IBAction func didTapLoginButton(_ sender: HKLoginButton) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions, viewController: self, completion: didReceiveFacebookLoginResult)
    }
}
