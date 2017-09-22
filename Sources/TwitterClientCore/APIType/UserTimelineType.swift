//
//  UserTimelineType.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/23.
//

import Foundation

import APIKit

struct UserTimelineType: TwitterAPIType {
    typealias Response = Tweets
    
    var oauth: TwitterOAuth
    var screenName: String
    var count: Int = 30
    var sinceId: Int?
    var maxId: Int?
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/1.1/statuses/user_timeline.json"
    }
    
    var parameters: Any? {
        var params: [String: Any] = ["screen_name": self.screenName, "count": self.count]
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
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Tweets {
        return try Tweets(object)
    }
}
