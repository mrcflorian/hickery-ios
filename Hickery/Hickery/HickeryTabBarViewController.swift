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
        configureTabBar()
    }

    private func configureTabBar() {
        self.tabBar.barTintColor = UIColor.black
        self.tabBar.tintColor = UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.0)
    }

    private func configureViewControllers() {
        homeVC = viewControllers?.first as? HomeViewController
        homeVC?.userId = userId
    }
}
