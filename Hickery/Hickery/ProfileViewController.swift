//
//  ProfileViewController.swift
//  Hickery
//
//  Created by Florian Marcu on 10/30/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import FacebookCore
import FacebookLogin
import Kingfisher
import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var syncFacebookButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var syncActivityIndicator: UIActivityIndicatorView!

    private var facebookSyncManager: FacebookSyncManager?

    var partialUser: HickeryUser? { // The user from facebook
        didSet {
            self.fetchUser()
        }
    }
    var wholeUser: HickeryUser? // The user from hickery
    var apiManager = APIManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateIfNeeded()
    }

    private func updateIfNeeded() {
        guard let avatarImageView = avatarImageView, let nameLabel = nameLabel else {
            return
        }
        guard let user = (wholeUser != nil) ? wholeUser : partialUser else {
            return
        }
        if let imageURL = URL(string: user.profileImageURL) {
            avatarImageView.kf.setImage(with: imageURL)
        }
        nameLabel.text = user.firstName + " " + user.lastName
    }

    private func fetchUser() {
        guard let partialUser = partialUser else {
            return
        }
        apiManager.requestUser(email: partialUser.email) { (hickeryUser) in
            self.wholeUser = hickeryUser
            self.updateIfNeeded()
        }
    }

    private func configureViews() {
        guard let avatarImageView = avatarImageView else {
            return
        }
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 15
    }

    @IBAction func didTapSyncFacebookButton(_ sender: UIButton) {
        guard let user = wholeUser else {
            return
        }
        if facebookSyncManager == nil {
            facebookSyncManager = FacebookSyncManager(facebookAPIManager: FacebookAPIManager(accessToken: AccessToken.current!), apiManager: APIManager())
        }
        sender.isHidden = true
        syncActivityIndicator.startAnimating()
        facebookSyncManager?.syncFacebookWallPosts(hickeryUser: user, completionBlock: { (songs) in
            self.syncActivityIndicator.stopAnimating()
            sender.isHidden = true
        })
    }

    @IBAction func didTapLogoutButton(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logOut()
        self.dismiss(animated: true, completion: nil)
    }
}
