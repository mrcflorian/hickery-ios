//
//  HickeryUser.swift
//  Hickery
//
//  Created by Florian Marcu on 10/30/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

class HickeryUser {

    var userID: String = ""
    var profileImageURL: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""

    init(facebookID: String) {
        userID = HickeryUser.hickeryID(facebookID)
    }

    init(jsonDictionary: [String:Any]) {
        if (jsonDictionary["hkid"] != nil) {
            userID = jsonDictionary["hkid"] as! String
        }
        if let profilePicture = jsonDictionary["large_profile_picture"] as? String {
            profileImageURL = profilePicture
        } else {
            if let profilePicture = jsonDictionary["profile_picture"] as? String {
                profileImageURL = profilePicture
            }
        }
        if let firstName = jsonDictionary["first_name"] as? String {
            self.firstName = firstName
        }
        if let lastName = jsonDictionary["last_name"] as? String {
            self.lastName = lastName
        }
        if let email = jsonDictionary["email"] as? String {
            self.email = email
        }
    }

    init(facebookUser: FacebookUser) {
        userID = HickeryUser.hickeryID(facebookUser.id)
        if let email = facebookUser.email {
            self.email = email
        }
        if let firstName = facebookUser.firstName {
            self.firstName = firstName
        }
        if let lastName = facebookUser.lastName {
            self.lastName = lastName
        }
        if let profileImageURL = facebookUser.profilePicture {
            self.profileImageURL = profileImageURL
        }
    }

    class func hickeryID(_ facebookID: String!) -> String {
        let repeatNo = max(0, 15 - facebookID.characters.count)
        let repeatedZeros = String(repeating: "0", count: repeatNo)
        let id = "99" + repeatedZeros + facebookID;
        if (id.characters.count > 20) {
            return repeatedZeros + facebookID
        }
        return id
    }
}
