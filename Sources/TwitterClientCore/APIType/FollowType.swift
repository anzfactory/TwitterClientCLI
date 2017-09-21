//
//  FollowType.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/22.
//

import Foundation

import APIKit

struct FollowType: TwitterAPIType {
    typealias Response = User
    
    var oauth: TwitterOAuth
    var userId: Int
    var screenName: String
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/1.1/friendships/create.json"
    }
    
    var parameters: Any? {
        return ["user_id": self.userId, "screen_name": self.screenName]
    }
    
    var bodyParameters: BodyParameters? {
        if let params = self.parameters as? [String: Any] {
            return FormURLEncodedBodyParameters(formObject: params, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> User {
        return try User(object)
    }
}
