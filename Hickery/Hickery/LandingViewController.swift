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

    override func viewDidAppear(_ animated: Bool) {
        if let _ = AccessToken.current {
            didLoginWithFacebook()
            return;
        }
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
        assert(AccessToken.current != nil)

        let signUpVC = SignUpViewController()
        self.present(signUpVC, animated: false, completion: nil)
        return

        let accessToken = AccessToken.current
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HickeryTabBarViewController") as! HickeryTabBarViewController
        vc.userId = HickeryUser.hickeryID(accessToken?.userId)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func didTapLoginButton(_ sender: HKLoginButton) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions, viewController: self, completion: didReceiveFacebookLoginResult)
    }
}
