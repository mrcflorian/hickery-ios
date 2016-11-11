//
//  FacebookAPIManager.swift
//  Hickery
//
//  Created by Florian Marcu on 11/10/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import FacebookCore
import FacebookLogin

let kGraphPathMe = "me"
let kGraphPathMePageLikes = "me/likes"

class FacebookAPIManager {

    let accessToken: AccessToken

    init(accessToken: AccessToken) {
        self.accessToken = accessToken
    }

    func requestFacebookUser(completion: @escaping (_ facebookUser: FacebookUser) -> Void) {
        let graphRequest = GraphRequest(graphPath: kGraphPathMe, parameters: ["fields":"id,email,last_name,first_name"], accessToken: accessToken, httpMethod: .GET, apiVersion: .defaultVersion)
        graphRequest.start { (response: HTTPURLResponse?, result: GraphRequestResult<GraphRequest>) in
            switch result {
            case .success(let graphResponse):
                if let dictionary = graphResponse.dictionaryValue {
                    let firstName = dictionary["first_name"] as? String
                    let lastName = dictionary["last_name"] as? String
                    let email = dictionary["email"] as? String
                    let id = dictionary["id"] as? String
                    let fbUser = FacebookUser(firstName: firstName, lastName: lastName, email: email, id: id)
                    completion(fbUser)
                }
                break
            default:
                print("Facebook request user error")
            }
        }
    }

    func requestWallPosts(completion: @escaping (_ posts: [FacebookPost]) -> Void) {
        let parameters = ["fields":"link,created_time,description,picture","limit":"25"]
        requestWallPosts(parameters: parameters, posts: [], completion: completion)
    }

    func requestFacebookUserPageLikes() {
        let graphRequest = GraphRequest(graphPath: kGraphPathMePageLikes, parameters: [:], accessToken: accessToken, httpMethod: .GET, apiVersion: .defaultVersion)
        graphRequest.start { (response: HTTPURLResponse?, result: GraphRequestResult<GraphRequest>) in
            print (result)
        }
    }

    private func requestWallPosts(parameters: [String:String], posts: [FacebookPost], completion: @escaping (_ posts: [FacebookPost]) -> Void) {
        print ("Start new request")
        let graphRequest = GraphRequest(graphPath: "me/posts", parameters: parameters, accessToken: accessToken, httpMethod: .GET, apiVersion: .defaultVersion)

        graphRequest.start { (response: HTTPURLResponse?, result: GraphRequestResult<GraphRequest>) in
            switch result {
            case .success(let graphResponse):
                var newPosts = [FacebookPost]()
                if let dictionary = graphResponse.dictionaryValue {
                    if let array = dictionary["data"] as? [[String: String]] {
                        for dict in array {
                            let fbPost = FacebookPost(dictionary: dict)
                            newPosts.append(fbPost)
                        }
                    }
                    print ("Loaded " + String(newPosts.count) + " more posts")
                    if let paging = dictionary["paging"] as? [String: String] {
                        if let next = paging["next"] as String? {
                            if next.characters.count > 0 {
                                var newParams = parameters
                                newParams["__paging_token"] = self.extractPagingToken(string: next)
                                self.requestWallPosts(parameters: parameters, posts: posts + newPosts, completion: completion)
                                return
                            }
                        }
                    }
                }
                completion(posts + newPosts)
                return
            default:
                print("Facebook me/posts error")
            }
            completion(posts)
        }
    }

    private func extractPagingToken(string: String) -> String? {
        if let urlComponents = URLComponents(string: string), let queryItems = (urlComponents.queryItems as [URLQueryItem]?) {
            return queryItems.filter({ (item) in item.name == "__paging_token" }).first?.value!
        }
        return nil
    }

}
