//
//  SongTableViewCell.swift
//  Hickery
//
//  Created by Florian Marcu on 11/3/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit

let kSongTableViewCellImageViewCornerRadius: CGFloat = 8.0

class SongTableViewCell: UITableViewCell {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    func configureCell() {
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = kSongTableViewCellImageViewCornerRadius
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
