//
//  HickerySong.swift
//  Hickery
//
//  Created by Florian Marcu on 10/30/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

class HickerySong: NSObject, NSCoding {

    var songID: String?
    var photoURL: String?
    var title: String?
    var content: String?
    var categoryID: String?
    var subcategoryID: String?

    init(jsonDictionary: [String:String]) {
        super.init()
        songID = jsonDictionary["hkid"]!
        photoURL = jsonDictionary["photo"]
        title = jsonDictionary["title"]
        content = jsonDictionary["content"]
        categoryID = jsonDictionary["category_id"]
        subcategoryID = jsonDictionary["subcategory_id"]
    }

    init(facebookPost: FacebookPost) {
        super.init()
        photoURL = facebookPost.picture
        content = facebookPost.link
        title = facebookPost.name
        songID = self.youtubeVideoID()
    }

    required init?(coder aDecoder: NSCoder) {
        songID = aDecoder.decodeObject(forKey: "songID") as? String
        photoURL = aDecoder.decodeObject(forKey: "photoURL") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        content = aDecoder.decodeObject(forKey: "content") as? String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.songID, forKey:"songID")
        aCoder.encode(self.photoURL, forKey:"photoURL")
        aCoder.encode(self.title, forKey:"title")
        aCoder.encode(self.content, forKey:"content")
    }

    func dictionary() -> [String: String]? {
        guard let photoURL = photoURL, let title = title, let content = content else {
            return nil
        }
        return ["photo": photoURL,
                "title": title,
                "content": content]
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
