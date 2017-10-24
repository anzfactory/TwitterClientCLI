//
//  RateLimit.swift
//  TwitterClientCLIPackageDescription
//
//  Created by shingo asato on 2017/10/09.
//

import Foundation

import APIKit
import Rainbow

struct RateLimit: Outputable {
    
    enum Path {
        case homeTimeline, userTimeline, tweet, retweet, search, favorites
        
        var string: String {
            switch self {
            case .homeTimeline:
                return "/statuses/home_timeline"
            case .userTimeline:
                return "/statuses/user_timeline"
            case .tweet:
                return "/statuses/show/:id"
            case .retweet:
                return "/statuses/retweets/:id"
            case .search:
                return "/search/tweets"
            case .favorites:
                return "/favorites/list"
            }
        }
        
        var name: String {
            switch self {
            case .homeTimeline:
                return "タイムライン"
            case .userTimeline:
                return "ユーザタイムライン"
            case .tweet:
                return "ツイート詳細"
            case .retweet:
                return "リツイート"
            case .search:
                return "ツイート検索"
            case .favorites:
                return "いいねリスト"
            }
        }
    }
    
    var list: [Path: RateLimitState] = [Path: RateLimitState]()
    
    init(_ object: Any) throws {
        guard let dictionary = object as? [String: Any], let resources = dictionary["resources"] as? [String: Any] else {
            throw ResponseError.unexpectedObject("unknown...")
        }
        
        if let statuses = resources["statuses"] as? [String: Any] {
            if let obj = statuses[Path.homeTimeline.string], let state = RateLimitState(obj) {
                self.list[.homeTimeline] = state
            }
            if let obj = statuses[Path.userTimeline.string], let state = RateLimitState(obj) {
                self.list[.userTimeline] = state
            }
            if let obj = statuses[Path.tweet.string], let state = RateLimitState(obj) {
                self.list[.tweet] = state
            }
            if let obj = statuses[Path.retweet.string], let state = RateLimitState(obj) {
                self.list[.retweet] = state
            }
        }
        
        if let search = resources["search"] as? [String: Any] {
            if let obj = search[Path.search.string], let state = RateLimitState(obj) {
                self.list[.search] = state
            }
        }
        
        if let favorites = resources["favorites"] as? [String: Any] {
            if let obj = favorites[Path.favorites.string], let state = RateLimitState(obj) {
                self.list[.favorites] = state
            }
        }
        
    }
    
    func output() -> String {
        var body = [String]()
        for (key, state) in self.list {
            body.append("\(key.name.bold) (\(key.string.underline))\n\(state.output())")
        }
        return body.joined(separator: "\n")
    }
    
}

struct RateLimitState: Outputable {
    let limit: Int
    let remaining: Int
    let resetTimestamp: Int
    
    init?(_ object: Any) {
        guard let obj = object as? [String: Any] else {
            return nil
        }
        
        self.limit = obj["limit"] as? Int ?? 0
        self.remaining = obj["remaining"] as? Int ?? 0
        self.resetTimestamp = obj["reset"] as? Int ?? 0
    }
    
    func output() -> String {
        let delta = self.resetTimestamp - Int(Date().timeIntervalSince1970)
        return "制限: \(self.limit)times/15min\n" +
        "残り: \(self.remaining)times\n" +
        "リセットまで: \(delta)sec\n"
    }
}
