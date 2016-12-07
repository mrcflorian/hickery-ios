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
let kHickeryAPIUserSignUpPath = "api/signup.php"
let kHickeryAPIUserUploadLikesPath = "api/upload_likes.php"

let kHickeryAPIParamUserIdKey = "user_id"
let kHickeryAPIParamQueryKey = "query"
let kHickeryAPIParamEmailKey = "email"

class APIManager {

    let localStore = LocalStore()
    let networkingManager = NetworkingManager()

    // MARK - Reads
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

    // MARK - Writes

    func signUpUser(facebookUser: FacebookUser, completion: @escaping (_ hickeryUser: HickeryUser) -> Void) {
        let params = ["fbid": facebookUser.id,
                      "first_name": facebookUser.firstName,
                      "last_name": facebookUser.lastName,
                      kHickeryAPIParamEmailKey: facebookUser.email,
                      "profile_picture": facebookUser.profilePicture]

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
        let params = [kHickeryAPIParamUserIdKey: hickeryUser.userID,
                      "objects": jsonLikes] as [String : String]
        networkingManager.post(path: kHickeryAPIUserUploadLikesPath, params: params) { (jsonResponse, responseStatus) in
            switch responseStatus {
            case .success:
                if let jsonResponse = jsonResponse as? [String: String] {
                    if (jsonResponse["result"] == "success") {
                        // succesful upload
                        completion()
                    }
                }
            case .error(let error):
                print(error)
            }
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
