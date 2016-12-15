//
//  FacebookSyncManager.swift
//  Hickery
//
//  Created by Florian Marcu on 12/15/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

class FacebookSyncManager {

    private let facebookAPIManager: FacebookAPIManager
    private let apiManager: APIManager

    init(facebookAPIManager: FacebookAPIManager, apiManager: APIManager) {
        self.facebookAPIManager = facebookAPIManager
        self.apiManager = apiManager
    }

    func syncFacebookWallPosts(hickeryUser: HickeryUser, completionBlock: @escaping ([HickerySong]) -> Void) {
        self.facebookAPIManager.requestWallPosts(completion: { (posts: [FacebookPost]) in
            self.sendPostsToHickery(hickeryUser: hickeryUser, fbPosts: posts, completionBlock:completionBlock)
        })
    }

    private func sendPostsToHickery(hickeryUser: HickeryUser, fbPosts: [FacebookPost], completionBlock: @escaping ([HickerySong]) -> Void) {
        let hickerySongs = fbPosts
            .map{HickerySong(facebookPost: $0)}
            .filter{$0.youtubeVideoID() != ""}
        if (hickerySongs.count > 0) {
            self.apiManager.uploadLikes(hickeryUser: hickeryUser, likes: hickerySongs, completion: { () in
                completionBlock(hickerySongs)
            })
        } else {
            completionBlock(hickerySongs)
        }
    }
}
