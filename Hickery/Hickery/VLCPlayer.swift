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
    public var delegate: PlaylistViewControllerDelegate?
    
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
        let media = VLCMedia(url: url! as URL)
        self.mediaPlayer.media = media
        self.mediaPlayer.play()
    }
    
    public func playVideo(videoId: String) {
        
        let apiManager = APIManager()
        // TODO: might be possible to fetch the audio files directly from this link and not use the second calls
        let url: String = "https://www.youtube.com/watch?gl=US&hl=en&has_verified=1&bpctr=9999999999&v=" + videoId
        print(url)
        
        apiManager.requestURL(url: url) { (result) in
            let strResult = result?.replacingOccurrences(of: "\\", with: "")
            let playerURL = self.getPlayerURL(strResult: strResult!)
            let sts = self.getSTS(strResult: strResult!)
            // el=detailpage works!!!!
            var infoURL = "https://www.youtube.com/get_video_info?el=detailpage&ps=default&video_id=" + videoId + "&hl=en&gl=US&eurl="

            if sts != "" {
                infoURL += "&sts=" + sts
            }
            apiManager.requestURL(url: infoURL) { (result) in
                let res = self.parseQuery(query: result!)
                let data = res["adaptive_fmts"]?.components(separatedBy: "%2C") // ','
                if data == nil {
                    print("Shit is nil")
                    self.delegate?.songFailedToPlay()
                    return;
                }
                let map = self.parseQuery(query: (data?.last)!.removingPercentEncoding!)
                let url = map["url"]!.removingPercentEncoding!
                if url.range(of: "signature=") != nil {
                    self.playAudio(audioURL: url + "&ratebypass=yes")
                } else {
                    apiManager.requestAudioSignature(player: playerURL, s: map["s"]!) { (signature) in
                        let audioURL = url + "&signature=" + signature + "&ratebypass=yes"
                        self.playAudio(audioURL: audioURL)
                    }
                }
                
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
    
    func parseQuery(query: String) -> [String:String] {
        var results = [String:String]()
        let keyValues = query.components(separatedBy: "&")
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
    
    /**
     * Ideally we would use this to run JS code of the youtube player to decrypt the signature.
     * Right now we run this on the server, for some reason this function is not working as expected
     */
    func runJS(jsSource: String, funcName: String, param: String) -> String {
        let context = JSContext()
        _ = context?.evaluateScript(jsSource)
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
        let keyValues = self.query?.components(separatedBy: "&")
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

protocol PlaylistViewControllerDelegate {
    func songFailedToPlay()
}
