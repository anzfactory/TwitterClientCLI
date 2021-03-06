//
//  Tweet.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/20.
//

import Foundation

import APIKit
import Rainbow

struct Tweet: Outputable {
    let id: Int
    let text: String
    let isFavorited: Bool
    let isRetweeted: Bool
    let user: User
    
    init(_ object: Any) throws {
        guard let dictionary = object as? [String: Any],
            let id = dictionary["id"] as? Int,
            let userDictionary = dictionary["user"] as? [String: Any],
            let text = dictionary["text"] as? String else {
                throw ResponseError.unexpectedObject(object)
        }
        self.id = id
        self.text = text
        self.isFavorited = dictionary["favorited"] as? Bool ?? false
        self.isRetweeted = dictionary["retweeted"] as? Bool ?? false
        self.user = try User(userDictionary)
    }
    
    func output() -> String {
        let header = "@\(self.user.screenName)（\(self.user.name)）".bold.underline + (self.user.isFollowing ? " ★".yellow : "")
        let body = "\(self.text)"
        var footer = "id: \(self.id)".lightMagenta + (self.isRetweeted ? " RT".green : "") + (self.isFavorited ? " ♥".cyan : "")
        let tweetUrl = URL(tweet: self)
        footer += "\n\(tweetUrl.absoluteString)".lightMagenta
        
        return  header + "\n" + body + "\n" + footer
    }
}
