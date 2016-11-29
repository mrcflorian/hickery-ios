//
//  HickerySongStream.swift
//  Hickery
//
//  Created by Florian Marcu on 10/30/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import UIKit

class HickerySongStream {

    static func parse(jsonResponse: Any?) -> [HickerySong] {
        var result = [HickerySong]()
        if let jsonArray = jsonResponse as? NSArray {
            for jsonSongDict in jsonArray {
                if let jsonDictionary = jsonSongDict as? [String : String] {
                    let song = HickerySong(jsonDictionary: jsonDictionary)
                    result.append(song)
                }
            }
        }
        return result.filter({$0.youtubeVideoID() != ""})
    }
}
