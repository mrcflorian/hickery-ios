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
let kHickeryAPIUserSearchPath = "api/search.php"
let kHickeryAPIUserPath = "api/user.php"

let kHickeryAPIParamUserIdKey = "user_id"
let kHickeryAPIParamQueryKey = "query"
let kHickeryAPIParamEmailKey = "email"

class APIManager {

    let localStore = LocalStore()
    let networkingManager = NetworkingManager()

    func requestLikes(userId: String, completion: @escaping (_ songs: [HickerySong]) -> Void) {
        if let songs = localStore.likes(forUserId: userId) {
            completion(songs)
            return
        }
        let params = [kHickeryAPIParamUserIdKey:userId]
        requestSongs(endpoint: kHickeryAPIUserLikesPath, params: params, completion: completion)
    }

    func requestRecommendations(userId: String, completion: @escaping (_ songs: [HickerySong]) -> Void) {
        let params = [kHickeryAPIParamUserIdKey:userId]
        requestSongs(endpoint: kHickeryAPIUserRecommendationsPath, params: params, completion: completion)
    }

    func requestSearchResults(userId: String, query: String, completion: @escaping (_ songs: [HickerySong]) -> Void) {
        let params = [kHickeryAPIParamUserIdKey:userId, kHickeryAPIParamQueryKey:query]
        requestSongs(endpoint: kHickeryAPIUserSearchPath, params: params, completion: completion)
    }

    func requestUser(email: String, completion: @escaping (_ user: HickeryUser?) -> Void) {
        let params = [kHickeryAPIParamEmailKey: email]
        networkingManager.get(path: kHickeryAPIUserPath, params: params) { (jsonResponse, responseStatus) in
            switch responseStatus {
            case .success:
                if let jsonResponse = jsonResponse as? [String : Any] {
                    let user = HickeryUser(jsonDictionary: jsonResponse)
                    completion(user)
                } else {
                    completion(nil)
                }
            case .error:
                completion(nil)
            }
        }
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
