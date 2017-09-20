//
//  AccessTokenType.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/20.
//

import Foundation

import APIKit

struct AccessTokenType: TwitterAPIType {
    typealias Response = AccessToken
    
    var oauth: TwitterOAuth
    var pinCode: String
    
    var method: HTTPMethod {
        return .post
    }
    
    var dataParser: DataParser {
        return FormURLEncodedDataParser(encoding: .utf8)
    }
    
    var path: String {
        return "/oauth/access_token"
    }
    
    var parameters: Any? {
        return ["oauth_verifier": self.pinCode]
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> AccessToken {
        return try AccessToken(object)
    }
}
