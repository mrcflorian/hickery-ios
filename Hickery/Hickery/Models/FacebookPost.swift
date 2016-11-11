//
//  FacebookPost.swift
//  Hickery
//
//  Created by Florian Marcu on 11/10/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

class FacebookPost {
    let link: String?
    let createdTime: String?
    let description: String?
    let picture: String?

    init (dictionary: [String: String]) {
        self.link = dictionary["link"] as String?
        self.description = dictionary["description"] as String?
        self.picture = dictionary["picture"] as String?
        self.createdTime = dictionary["created_time"] as String?
    }

    init(link: String?, createdTime: String?, description: String?, picture: String?) {
        self.link = link
        self.createdTime = createdTime
        self.description = description
        self.picture = picture
    }
}
