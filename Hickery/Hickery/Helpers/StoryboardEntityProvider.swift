//
//  StoryboardEntityProvider.swift
//  Hickery
//
//  Created by Florian Marcu on 11/6/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit

class StoryboardEntityProvider {

    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

    func playlistViewController() -> PlaylistViewController {
        return mainStoryboard.instantiateViewController(withIdentifier: "PlaylistViewController") as! PlaylistViewController
    }
}
