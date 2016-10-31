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
        if jsonResponse != nil && jsonResponse! is NSArray {
            let jsonArray = jsonResponse! as! NSArray
            for jsonSongDict in jsonArray {
                if jsonSongDict is [String : String] {
                    let song = HickerySong(jsonDictionary: jsonSongDict as! [String : String])
                    result.append(song)
                }
            }
        }
        return result
    }

}
