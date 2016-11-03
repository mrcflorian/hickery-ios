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

    var indexPathOfCurrentPlayingSong = IndexPath(row: -1, section: 0)

    func getNextSongForPlaying() -> HickerySong? {
        let newIndexPath = IndexPath(row: indexPathOfCurrentPlayingSong.row + 1, section: indexPathOfCurrentPlayingSong.section)
        if let hickerySong = self.hickerySong(forIndexPath: newIndexPath) {
            indexPathOfCurrentPlayingSong = newIndexPath
            self.tableView.selectRow(at: indexPathOfCurrentPlayingSong, animated: true, scrollPosition: .top)
            return hickerySong
        }
        return nil
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
            indexPathOfCurrentPlayingSong = indexPath
            self.tableView.scrollToRow(at: indexPathOfCurrentPlayingSong, at: .top, animated: true)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
