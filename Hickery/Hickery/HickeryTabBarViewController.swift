//
//  HickeryTabBarViewController.swift
//  Hickery
//
//  Created by Florian Marcu on 10/30/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit

class HickeryTabBarViewController: UITabBarController {

    var homeVC: HomeViewController?

    var userId: String? {
        didSet {
            homeVC?.userId = userId
        }
    }

    override func viewDidLoad() {
        configureViewControllers()
    }

    private func configureViewControllers() {
        homeVC = viewControllers?.first as? HomeViewController
        homeVC?.userId = userId
    }
}
