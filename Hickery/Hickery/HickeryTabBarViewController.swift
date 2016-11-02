//
//  HickeryTabBarViewController.swift
//  Hickery
//
//  Created by Florian Marcu on 10/30/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit

class HickeryTabBarViewController: UITabBarController {

    var likesPlayListVC: PlaylistViewController?

    var userId: String? {
        didSet {
            likesPlayListVC?.userId = userId
        }
    }

    override func viewDidLoad() {
        configureViewControllers()
    }

    private func configureViewControllers() {
        likesPlayListVC = viewControllers?.first as? PlaylistViewController
        likesPlayListVC?.userId = userId
    }
}
