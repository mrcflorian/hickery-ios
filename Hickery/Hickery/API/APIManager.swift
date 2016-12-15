//
//  APIManager.swift
//  Hickery
//
//  Created by Florian Marcu on 10/30/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import Foundation
import FacebookCore

let kHickeryAPIUserLikesPath = "api/likes.php"
let kHickeryAPIUserRecommendationsPath = "api/recommendations.php"
let kHickeryAPIUserSearchPath = "api/search.php"
let kHickeryAPIUserPath = "api/user.php"
let kHickeryAPIUserSignUpPath = "api/signup.php"
let kHickeryAPIUserUploadLikesPath = "api/upload_likes.php"
let kHickeryAPIUserLikePath = "api/like.php"

let kHickeryAPIParamUserIdKey = "user_id"
let kHickeryAPIParamObjectIdKey = "object_id"
let kHickeryAPIParamQueryKey = "query"
let kHickeryAPIParamEmailKey = "email"
let kHickeryAPIParamIsDislikeIdKey = "is_dislike"

class APIManager {

    let networkingManager = NetworkingManager()

    // MARK - Reads
    func requestLikes(userId: String, completion: @escaping (_ songs: [HickerySong]) -> Void) {
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
        var params = [kHickeryAPIParamEmailKey: email]

        if let token = AccessToken.current {
            params["access_token"] = token.authenticationToken
        }

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

    // MARK - Writes

    func signUpUser(facebookUser: FacebookUser, completion: @escaping (_ hickeryUser: HickeryUser) -> Void) {
        var params = ["fbid": facebookUser.id,
                      "first_name": facebookUser.firstName,
                      "last_name": facebookUser.lastName,
                      kHickeryAPIParamEmailKey: facebookUser.email,
                      "profile_picture": facebookUser.profilePicture]

        if let token = AccessToken.current {
            params["access_token"] = token.authenticationToken
        }

        if let params = params as? [String: String] {
            networkingManager.post(path: kHickeryAPIUserSignUpPath, params: params) { (jsonResponse, responseStatus) in
                switch responseStatus {
                case .success:
                    if let jsonResponse = jsonResponse as? [String: Any] {
                        completion(HickeryUser(jsonDictionary: jsonResponse))
                    }
                case .error(let error):
                    print(error)
                }
            }
        }
    }

    func uploadLikes(hickeryUser: HickeryUser, likes: [HickerySong], completion: @escaping () -> Void) {
        let likesDictionaries = likes.flatMap{$0.dictionary()}
        guard let jsonData = try? JSONSerialization.data(withJSONObject: likesDictionaries, options: .prettyPrinted) else {
            return
        }
        guard let jsonLikes = String(data: jsonData, encoding: .utf8) else {
            return
        }
        var params = [kHickeryAPIParamUserIdKey: hickeryUser.userID,
                      "objects": jsonLikes] as [String : String]

        if let token = AccessToken.current {
            params["access_token"] = token.authenticationToken
        }

        networkingManager.post(path: kHickeryAPIUserUploadLikesPath, params: params) { (jsonResponse, responseStatus) in
            switch responseStatus {
            case .success: break
                // TODO: Scribe success
            case .error: break
                // TODO: Scribe error
            }
            completion()
        }
    }

    func like(hickeryUser: HickeryUser, hickerySong: HickerySong, isDislike: Bool, completion: @escaping () -> Void) {
        let userId = hickeryUser.userID
        guard let songId = hickerySong.songID else {
            return
        }
        var params = [kHickeryAPIParamUserIdKey:userId,
                      kHickeryAPIParamObjectIdKey: songId]
        if isDislike {
            params[kHickeryAPIParamIsDislikeIdKey] = "true";
        }
        networkingManager.get(path: kHickeryAPIUserLikePath, params: params) { (jsonResponse, responseStatus) in
            completion()
        }
    }

    // MARK - Private

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
