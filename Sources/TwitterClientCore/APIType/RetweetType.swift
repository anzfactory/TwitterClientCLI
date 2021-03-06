//
//  RetweetType.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/21.
//

import Foundation

import APIKit

struct RetweetType: TwitterAPIType {
    typealias Response = Tweet
    
    var oauth: TwitterOAuth
    var tweetId: Int
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/1.1/statuses/retweet/\(self.tweetId).json"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Tweet {
        return try Tweet(object)
    }
}
