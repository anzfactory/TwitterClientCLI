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
    var sinceId: Int?
    var maxId: Int?
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/1.1/search/tweets.json"
    }
    
    var parameters: Any? {
        var params: [String: Any] = ["q": self.q, "count": self.count]
        if let sinceId = self.sinceId, sinceId > 0 {
            params["since_id"] = sinceId
        }
        if let maxId = self.maxId, maxId > 0 {
            params["max_id"] = maxId
        }
        return params
    }   
    
    var queryParameters: [String : Any]? {
        return self.parameters as? [String: Any]
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> SearchTweets {
        return try SearchTweets(object)
    }
}

