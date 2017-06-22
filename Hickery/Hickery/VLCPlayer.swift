//
//  VLCPlayer.swift
//  Hickery
//
//  Created by Mircea Dima on 6/16/17.
//  Copyright © 2017 Florian Marcu. All rights reserved.
//

import Foundation
import PySwiftyRegex
import JavaScriptCore


class VLCPlayer {
    public static let instance = VLCPlayer()
    public var mediaPlayer = VLCMediaPlayer()
    
    public static func getInstance() -> VLCPlayer {
        return self.instance
    }
    
    public func play() {
        self.mediaPlayer.play()
    }
    public func pause() {
        self.mediaPlayer.pause()
    }
    public func stop() {
        self.mediaPlayer.stop()
    }
    
    public func isPlaying() -> Bool {
        return self.mediaPlayer.isPlaying
    }
    
    public func playAudio(audioURL: String) {
        let url = NSURL(string: audioURL)
        let media = VLCMedia(url: url as! URL)
        self.mediaPlayer.media = media
        self.mediaPlayer.play()
    }
    
    public func playVideo(videoId: String) {
        if self.isPlaying() {
            self.mediaPlayer.stop()
        }
        let apiManager = APIManager()
        let url: String = "https://www.youtube.com/watch?gl=US&hl=en&has_verified=1&bpctr=9999999999&v=" + videoId
        //let url: String = "https://www.youtube.com/watch?v=" + videoId
        
        print(url)
        
        apiManager.requestURL(url: url) { (result) in
            do {
                let strResult = result?.replacingOccurrences(of: "\\", with: "")
                //print(strResult)
                let playerURL = self.getPlayerURL(strResult: strResult!)
                let sts = self.getSTS(strResult: strResult!)
                //let baseAudioURL = self.getBaseAudioURL(strResult: strResult!)
                
                print("Player URL: " + playerURL)
                
                var infoURL = "https://www.youtube.com/get_video_info?el=info&ps=default&video_id=" + videoId + "&hl=en&gl=US&eurl="
                if sts != "" {
                    infoURL += "&sts=" + sts
                }
                apiManager.requestURL(url: infoURL) { (result) in
                    //print(result)
                    //let resString = result?.removingPercentEncoding
                    let res = self.parseQuery(query: result!)
                    let data = res["adaptive_fmts"]?.components(separatedBy: "%2C") // ','
                    let map = self.parseQuery(query: (data?.last)!.removingPercentEncoding!)
                    var url = map["url"]!.removingPercentEncoding!
                    if url.range(of: "signature=") != nil {
                        self.playAudio(audioURL: url + "&ratebypass=yes")
                    } else {
                    
                        apiManager.requestAudioSignature(player: playerURL, s: map["s"]!) { (signature) in
                            let audioURL = url + "&signature=" + signature + "&ratebypass=yes"
                            self.playAudio(audioURL: audioURL)
                        }
                    }
                    
                }
            }catch {
                print(error)
            }
        }
    }
    
    func getPlayerURL(strResult: String) -> String {
        let regex: String = "\"assets\":.+?\"js\":\\s*(\"[^\"]+\")"
        var res = ""
        if let m = re.search(regex, strResult) {
            res = m.group(0)!
        }
        res = "{" + res + "}}"
        do {
            if let json = try JSONSerialization.jsonObject(with: res.data(using: String.Encoding.utf8)!) as? [String: Any],
                let assets = json["assets"] as? [String: Any] {
                let player = assets["js"] as? String
                res = player!
            }
        } catch {
            print(error)
        }
        return "https://www.youtube.com" + res
    }
    
    func getBaseAudioURL(strResult: String) -> String {
        let regex: String = "url="
        var res = ""
        //print(strResult)
        if let m = re.search(regex, strResult) {
            res = m.group(0)!
        }
        print("fmts: " + res)
        return ""
    }
    
    func parseQuery(query: String) -> [String:String] {
        var results = [String:String]()
        var keyValues = query.components(separatedBy: "&")
        if (keyValues.count) > 0 {
            for pair in keyValues {
                let kv = pair.components(separatedBy: "=")
                if kv.count > 1 {
                    results.updateValue(kv[1], forKey: kv[0])
                }
            }
            
        }
        return results
    }
    
    func runJS(jsSource: String, funcName: String, param: String) -> String {
        var context = JSContext()
        let ress = context?.evaluateScript(jsSource)
        let testFunction = context?.objectForKeyedSubscript(funcName)
        let result = testFunction?.call(withArguments: [param])
        return (result?.toString())!
    }
    
    func getSTS(strResult: String) -> String {
        var res = ""
        if let m = re.search("\"sts\"\\s*:\\s*(\\d+)", strResult) {
            res = m.group(0)!
        }
        res = "{" + res + "}"
        do {
            if let json = try JSONSerialization.jsonObject(with: res.data(using: String.Encoding.utf8)!) as? [String: Any] {
                let sts = json["sts"] as? Int
                res = String(sts!)
            }
        } catch {
            print(error)
        }

        return res;
    }
}


extension NSURL {
    func getKeyVals() -> Dictionary<String, String>? {
        var results = [String:String]()
        var keyValues = self.query?.components(separatedBy: "&")
        if (keyValues?.count)! > 0 {
            for pair in keyValues! {
                let kv = pair.components(separatedBy: "=")
                if kv.count > 1 {
                    results.updateValue(kv[1], forKey: kv[0])
                }
            }
            
        }
        return results
    }
}
