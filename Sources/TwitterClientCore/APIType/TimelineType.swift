//
//  TimelineType.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/20.
//

import Foundation

import APIKit

struct TimelineType: TwitterAPIType {
    typealias Response = Tweets
    
    var oauth: TwitterOAuth
    var count: Int = 30
    var sinceId: Int?
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/1.1/statuses/home_timeline.json"
    }
    
    var parameters: Any? {
        if let sinceId = self.sinceId, sinceId > 0 {
            return ["count": self.count, "since_id": sinceId]
        } else {
            return ["count": self.count]
        }
    }
    
    var queryParameters: [String : Any]? {
        return self.parameters as? [String: Any]
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Tweets {
        return try Tweets(object)
    }
}
