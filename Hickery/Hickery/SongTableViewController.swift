//
//  SongTableViewController.swift
//  Hickery
//
//  Created by Florian Marcu on 11/1/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit
import Kingfisher

protocol SongTableViewControllerDelegate {
    func songTableViewController(_ songTableViewController: SongTableViewController, didSelectHickerySong hickerySong: HickerySong)
}

class SongTableViewController: UITableViewController {

    var songTableViewControllerDelegate: SongTableViewControllerDelegate?

    var songs: [HickerySong]? {
        didSet {
            self.tableView.reloadData()
        }
    }

    func scrollToSongIndex(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if songs != nil {
            return songs!.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath) as! SongTableViewCell
        cell.configureCell()
        if let hickeryObject = self.hickerySong(forIndexPath: indexPath) {
            if let imageURLString = hickeryObject.photoURL {
                let imageURL = URL(string: imageURLString)
                cell.avatarImageView.kf.setImage(with: imageURL)
            }
            cell.titleLabel.text = hickeryObject.title
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let hickerySong = self.hickerySong(forIndexPath: indexPath) {
            songTableViewControllerDelegate?.songTableViewController(self, didSelectHickerySong: hickerySong)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    // MARK: - Private

    private func hickerySong(forIndexPath indexPath: IndexPath) -> HickerySong? {
        if (songs == nil) {
            return nil
        }
        if (songs!.count < indexPath.row) {
            return nil
        }
        return songs![indexPath.row]
    }
}
