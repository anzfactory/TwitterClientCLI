//
//  RateLimitType.swift
//  TwitterClientCLIPackageDescription
//
//  Created by shingo asato on 2017/10/09.
//

import Foundation

import APIKit

struct RateLimitType: TwitterAPIType {
    typealias Response = RateLimit
    
    var oauth: TwitterOAuth
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/1.1/application/rate_limit_status.json"
    }
    
    var parameters: Any? {
        return [
            "resources": "favorites,search,statuses,friendships"
        ]
    }
    
    var queryParameters: [String : Any]? {
        return self.parameters as? [String: Any]
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> RateLimit {
        return try RateLimit(object)
    }
    
}
