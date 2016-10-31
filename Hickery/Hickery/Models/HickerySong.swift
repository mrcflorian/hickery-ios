//
//  HickerySong.swift
//  Hickery
//
//  Created by Florian Marcu on 10/30/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

class HickerySong {

    var songID: String?
    var photoURL: String?
    var title: String?
    var content: String?
    var categoryID: String?
    var subcategoryID: String?

    init(jsonDictionary: [String:String]) {
        songID = jsonDictionary["hkid"]!
        photoURL = jsonDictionary["photo"]
        title = jsonDictionary["title"]
        content = jsonDictionary["content"]
        categoryID = jsonDictionary["category_id"]
        subcategoryID = jsonDictionary["subcategory_id"]
    }

    func youtubeVideoID() -> String {
        if let query = self.content?.components(separatedBy: "?")[1] {
            let pairs = query.components(separatedBy: "&")
            for pair in pairs {
                var kv = pair.components(separatedBy: "=")
                if (kv[0] == "v") {
                    return kv[1]
                }
            }
        }
        return ""
    }
}
