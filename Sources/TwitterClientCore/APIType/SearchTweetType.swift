//
//  SearchTweetType.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/21.
//

import Foundation

import APIKit

struct SearchTweetType: TwitterAPIType {
    typealias Response = SearchTweets
    var oauth: TwitterOAuth
    var q: String
    var count: Int = 30
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/1.1/search/tweets.json"
    }
    
    var parameters: Any? {
        return ["q": self.q, "count": self.count]
    }   
    
    var queryParameters: [String : Any]? {
        return self.parameters as? [String: Any]
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> SearchTweets {
        return try SearchTweets(object)
    }
}

