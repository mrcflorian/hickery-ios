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

    init(jsonDictionary: [String:String]) {
        if (jsonDictionary["hkid"] != nil) {
            userID = jsonDictionary["hkid"]!
        }
        if (jsonDictionary["profile_picture"] != nil) {
            profileImageURL = jsonDictionary["profile_picture"]!
        }
        if (jsonDictionary["first_name"] != nil) {
            firstName = jsonDictionary["first_name"]!
        }
        if (jsonDictionary["last_name"] != nil) {
            lastName = jsonDictionary["last_name"]!
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
