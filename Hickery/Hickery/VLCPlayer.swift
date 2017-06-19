//
//  VLCPlayer.swift
//  Hickery
//
//  Created by Mircea Dima on 6/16/17.
//  Copyright © 2017 Florian Marcu. All rights reserved.
//

import Foundation
import PySwiftyRegex

class VLCPlayer {
    public static let instance = VLCPlayer()
    public var mediaPlayer = VLCMediaPlayer()
    
    public static func getInstance() -> VLCPlayer {
        return self.instance
    }
    
    public func play() {
        self.mediaPlayer.play()
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
        let apiManager = APIManager()
        let url: String = "https://www.youtube.com/watch?gl=US&hl=en&has_verified=1&bpctr=9999999999&v=" + videoId
        apiManager.requestURL(url: url) { (result) in
            do {
                let strResult = result?.replacingOccurrences(of: "\\", with: "")
                //print(strResult)
                let playerURL = self.getPlayerURL(strResult: strResult!)
                let baseAudioURL = self.getBaseAudioURL(strResult: strResult!)
                print("Player URL: " + playerURL)
                
                let infoURL = "https://www.youtube.com/get_video_info?el=info&ps=default&video_id=" + videoId + "&hl=en&sts=17325&gl=US&eurl="
                apiManager.requestURL(url: infoURL) { (result) in
                    //print(result)
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
        let regex: String = "\"adaptive_fmts\":\""
        var res = ""
        if let m = re.search(regex, strResult) {
            res = m.group(0)!
        }
        print("fmts: " + res)
        return ""
    }
    
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
