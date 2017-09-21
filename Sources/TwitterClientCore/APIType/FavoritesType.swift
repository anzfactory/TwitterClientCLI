//
//  FavoritesType.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/21.
//

import Foundation

import APIKit

struct FavoritesType: TwitterAPIType {
    typealias Response = Tweets
    
    var oauth: TwitterOAuth
    var count: Int = 30
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/1.1/favorites/list.json"
    }
    
    var parameters: Any? {
        return ["count": self.count]
    }
    
    var queryParameters: [String : Any]? {
        return self.parameters as? [String: Any]
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Tweets {
        return try Tweets(object)
    }
}
