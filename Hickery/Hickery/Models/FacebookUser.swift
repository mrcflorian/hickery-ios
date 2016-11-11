//
//  FacebookUser.swift
//  Hickery
//
//  Created by Florian Marcu on 11/10/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

class FacebookUser {
    let firstName: String?
    let lastName: String?
    let email: String?
    let id: String?

    init (dictionary: [String: String]) {
        self.firstName = dictionary["first_name"] as String?
        self.lastName = dictionary["last_name"] as String?
        self.email = dictionary["email"] as String?
        self.id = dictionary["id"] as String?
    }

    init (firstName: String?, lastName: String?, email: String?, id: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.id = id
    }
}
