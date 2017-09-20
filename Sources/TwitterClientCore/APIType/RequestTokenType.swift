//
//  RequestTokenType.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/20.
//

import Foundation

import APIKit

struct RequestTokenType: TwitterAPIType {
    typealias Response = RequestToken
    
    var oauth: TwitterOAuth
    
    var method: HTTPMethod {
        return .post
    }
    
    var dataParser: DataParser {
        return FormURLEncodedDataParser(encoding: .utf8)
    }
    
    var path: String {
        return "/oauth/request_token"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> RequestToken {
        return try RequestToken(object)
    }
    
}
