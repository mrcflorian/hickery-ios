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
    var discoverVC: DiscoverViewController?
    var searchVC: SearchViewController?
    var profileVC: ProfileViewController?

    var user: HickeryUser?

    override func viewDidLoad() {
        configureViewControllers()
        configureTabBar()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.tabBar.isHidden = UIDevice.current.orientation.isLandscape
    }

    private func configureTabBar() {
        self.tabBar.barTintColor = UIColor.black
        self.tabBar.tintColor = UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.0)
    }

    private func configureViewControllers() {
        guard let user = user else {
            return
        }
        homeVC = viewControllers?.first as? HomeViewController
        homeVC?.userId = user.userID

        discoverVC = viewControllers?[1] as? DiscoverViewController
        discoverVC?.userId = user.userID

        searchVC = viewControllers?[2] as? SearchViewController
        searchVC?.userId = user.userID

        profileVC = viewControllers?[3] as? ProfileViewController
        profileVC?.partialUser = user
    }
}
