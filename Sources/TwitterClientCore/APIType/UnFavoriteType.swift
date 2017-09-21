//
//  UnFavoriteType.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/21.
//

import Foundation

import APIKit

struct UnFavoriteType: TwitterAPIType {
    typealias Response = Tweet
    
    var oauth: TwitterOAuth
    var tweetId: Int
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/1.1/favorites/destroy.json"
    }
    
    var parameters: Any? {
        return ["id": self.tweetId]
    }
    
    var bodyParameters: BodyParameters? {
        if let params = self.parameters as? [String: Any] {
            return FormURLEncodedBodyParameters(formObject: params, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Tweet {
        return try Tweet(object)
    }
}
