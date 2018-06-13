//
//  HickeryTabBarViewController.swift
//  Hickery
//
//  Created by Florian Marcu on 10/30/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit

class HickeryTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    var homeVC: HomeViewController?
    var discoverVC: DiscoverViewController?
    var searchVC: SearchViewController?
    var profileVC: ProfileViewController?

    var user: HickeryUser?

    static var tabBarHeight: CGFloat = 49

    static func startLoggedInExperience(facebookUser: FacebookUser, controller: UIViewController) {
        if let vc = StoryboardEntityProvider().hickeryTabBarViewController() {
            vc.user = HickeryUser(facebookUser: facebookUser)
            controller.present(vc, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        self.delegate = self
        configureViewControllers()
        configureTabBar()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.tabBar.isHidden = UIDevice.current.orientation.isLandscape
    }

    private func configureTabBar() {
        self.tabBar.barTintColor = UIColor.black
        self.tabBar.tintColor = UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.0)
        HickeryTabBarViewController.tabBarHeight = self.tabBar.frame.height
    }

    private func configureViewControllers() {
        guard let user = user else {
            return
        }
        homeVC = viewControllers?.first as? HomeViewController
        homeVC?.user = user

        discoverVC = viewControllers?[1] as? DiscoverViewController
        discoverVC?.user = user

        searchVC = viewControllers?[2] as? SearchViewController
        searchVC?.user = user

        profileVC = viewControllers?[3] as? ProfileViewController
        profileVC?.partialUser = user
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
    }
}
