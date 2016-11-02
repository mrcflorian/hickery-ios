//
//  APIManager.swift
//  Hickery
//
//  Created by Florian Marcu on 10/30/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import Foundation

let kHickeryAPIParamUserIdKey = "user_id"
let kHickeryAPIUserLikesPath = "api/likes.php"

class APIManager {

    let networkingManager = NetworkingManager()

    func requestLikes(userId: String, completion: @escaping (_ songs: [HickerySong]) -> Void) {
        let params = [kHickeryAPIParamUserIdKey:userId]
        networkingManager.get(path: kHickeryAPIUserLikesPath, params: params) { (jsonResponse, responseStatus) in
            switch responseStatus {
            case .success:
                let array = HickerySongStream.parse(jsonResponse: jsonResponse)
                completion(array)
            case .error(let error):
                print(error)
            }
        }
    }
}
