//
//  SearchViewController.swift
//  Hickery
//
//  Created by Florian Marcu on 11/3/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }

    @IBOutlet var containerView: UIView!

    let apiManager = APIManager()
    let playlistVC = StoryboardEntityProvider().playlistViewController()
    var userId: String?

    func didFetchSearchSongs(songs: [HickerySong]) {
        playlistVC.songs = songs
        containerView.addSubview(playlistVC.view)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, let userId = userId else {
            return
        }
        apiManager.requestSearchResults(userId: userId, query: query) { (songs) in
            self.didFetchSearchSongs(songs: songs)
        }
    }
}
