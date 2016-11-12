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
        if (jsonDictionary["large_profile_picture"] != nil) {
            profileImageURL = jsonDictionary["large_profile_picture"] as! String
        } else {
            if (jsonDictionary["profile_picture"] != nil) {
                profileImageURL = jsonDictionary["profile_picture"] as! String
            }
        }
        if (jsonDictionary["first_name"] != nil) {
            firstName = jsonDictionary["first_name"] as! String
        }
        if (jsonDictionary["last_name"] != nil) {
            lastName = jsonDictionary["last_name"] as! String
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
        var repeatNo = 15 - facebookID.characters.count
        if repeatNo < 0 {
            repeatNo = 0
        }
        return "99" + facebookID;
    }
}
