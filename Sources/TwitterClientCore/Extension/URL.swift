//
//  URL.swift
//  Spectre
//
//  Created by shingo asato on 2017/10/05.
//

import Foundation

extension URL {
    
    init(tweet: Tweet) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "twitter.com"
        components.path = "/\(tweet.user.screenName)/status/\(tweet.id)"
        self = components.url!
    }
}
