//
//  APIManager.swift
//  Hickery
//
//  Created by Florian Marcu on 10/30/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import Foundation

let kHickeryAPIUserLikesPath = "api/likes.php"
let kHickeryAPIUserRecommendationsPath = "api/recommendations.php"

let kHickeryAPIParamUserIdKey = "user_id"

class APIManager {

    let networkingManager = NetworkingManager()

    func requestLikes(userId: String, completion: @escaping (_ songs: [HickerySong]) -> Void) {
        let params = [kHickeryAPIParamUserIdKey:userId]
        requestSongs(endpoint: kHickeryAPIUserLikesPath, params: params, completion: completion)
    }

    func requestRecommendations(userId: String, completion: @escaping (_ songs: [HickerySong]) -> Void) {
        let params = [kHickeryAPIParamUserIdKey:userId]
        requestSongs(endpoint: kHickeryAPIUserRecommendationsPath, params: params, completion: completion)
    }

    private func requestSongs(endpoint: String, params: [String:String], completion: @escaping (_ songs: [HickerySong]) -> Void) {
        networkingManager.get(path: endpoint, params: params) { (jsonResponse, responseStatus) in
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
