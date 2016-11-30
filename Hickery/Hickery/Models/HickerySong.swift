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

    init(facebookPost: FacebookPost) {
        photoURL = facebookPost.picture
        content = facebookPost.link
        title = facebookPost.name
        songID = self.youtubeVideoID()
    }

    func youtubeVideoID() -> String {
        if let components = self.content?.components(separatedBy: "?") {
            if (components.count <= 1) {
                return ""
            }
            let query = components[1]
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
