//
//  NetworkingManager.swift
//  Hickery
//
//  Created by Florian Marcu on 10/30/16.
//  Copyright © 2016 Florian Marcu. All rights reserved.
//

import AFNetworking

let kHickeryRootURLString = "http://www.hickery.net/"

enum ResponseStatus {
    case success
    case error(error: String)
}

class NetworkingManager {

    let url = NSURL(string: kHickeryRootURLString) as URL?

    func get(path: String, params: [String:String]?, completion: ((_ jsonResponse: Any?, _ responseStatus: ResponseStatus) -> Void)?) {
        let manager = AFHTTPSessionManager(baseURL: url)
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()

        manager.get(path, parameters: params, progress: nil, success: { (dataTask, response) in
            if completion != nil {
                completion!(response, .success)
            }
        }) { (dataTask, error) in
            if completion != nil {
                completion!("", .error(error: error.localizedDescription))
            }
        }
    }
    
    func getText(url: String, params: [String: String]?, completion: ((_ jsonResponse: Any?, _ responseStatus: ResponseStatus) -> Void)?) {
        print("url: " + url)
        let manager = AFHTTPSessionManager()//baseURL: NSURL(string: url) as URL?)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = nil;
        
        manager.get(url, parameters: params, progress: nil, success: { (dataTask, response) in
            let res: NSData = response as! NSData
            var backToString = String(data: res as Data, encoding: String.Encoding.utf8) as String!
            if completion != nil {
                completion!(backToString, .success)
            }
        }) { (dataTask, error) in
            print("eroare: " + (error as! String))
            if completion != nil {
                completion!("", .error(error: error.localizedDescription))
            }
        }
    }

    // TODO: Refactor get and post  (DRY)
    func post(path: String, params: [String:String]?, completion: ((_ jsonResponse: Any?, _ responseStatus: ResponseStatus) -> Void)?) {
        let manager = AFHTTPSessionManager(baseURL: url)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()

        manager.post(path, parameters: params, progress: nil, success: { (dataTask, response) in
            if completion != nil {
                completion!(response, .success)
            }
        }) { (dataTask, error) in
            if completion != nil {
                completion!("", .error(error: error.localizedDescription))
            }
        }
    }
}
