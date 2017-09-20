//
//  RequestToken.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/20.
//

import Foundation

import APIKit

struct RequestToken {
    let oauthToken: String
    let oauthTokenSecret: String
    
    init(_ object: Any) throws {
        guard let dictionary = object as? [String: Any],
            let oauthToken = dictionary["oauth_token"] as? String,
            let oauthTokenSecret = dictionary["oauth_token_secret"] as? String else {
                throw ResponseError.unexpectedObject(object)
        }
        self.oauthToken = oauthToken
        self.oauthTokenSecret = oauthTokenSecret
    }
}


