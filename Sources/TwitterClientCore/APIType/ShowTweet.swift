//
//  ShowTweet.swift
//  TwitterClientCLIPackageDescription
//
//  Created by shingo asato on 2017/10/08.
//

import Foundation

import APIKit

struct ShowTweetType: TwitterAPIType {
    typealias Response = Tweet
    
    var oauth: TwitterOAuth
    var tweetId: Int
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/1.1/statuses/show.json"
    }
    
    var parameters: Any? {
        return ["id": self.tweetId]
    }
    
    var queryParameters: [String : Any]? {
        return self.parameters as? [String: Any]
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Tweet {
        return try Tweet(object)
    }
}
