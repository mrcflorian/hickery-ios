//
//  FacebookUser.swift
//  Hickery
//
//  Created by Florian Marcu on 11/10/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

class FacebookUser {
    var firstName: String?
    var lastName: String?
    var email: String?
    var id: String?

    init (firstName: String?, lastName: String?, email: String?, id: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.id = id
    }
}
