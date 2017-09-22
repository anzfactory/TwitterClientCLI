//
//  TweetType.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/20.
//

import Foundation

import APIKit

struct TweetType: TwitterAPIType {
    typealias Response = Tweet
    
    var oauth: TwitterOAuth
    var message: String
    var replyId: Int?
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/1.1/statuses/update.json"
    }
    
    var parameters: Any? {
        var params: [String: Any] = ["status": self.message]
        if let replyId = self.replyId, replyId > 0 {
            params["in_reply_to_status_id"] = replyId
        }
        return params
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
