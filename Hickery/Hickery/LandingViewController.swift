//
//  LandingViewController.swift
//  Hickery
//
//  Created by Florian Marcu on 10/30/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import FacebookLogin
import UIKit

class LandingViewController: UIViewController {

    @IBOutlet var fbLoginContainerView: UIView!

    override func viewDidLoad() {
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])

        fbLoginContainerView.addSubview(loginButton)
    }
}
