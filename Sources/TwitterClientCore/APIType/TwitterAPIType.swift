//
//  TwitterAPIType.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/20.
//

import Foundation

import APIKit

protocol TwitterAPIType: Request {
    var oauth: TwitterOAuth { get }
}

extension TwitterAPIType {
    
    var baseURL: URL {
        return URL(string: "https://api.twitter.com")!
    }
    
    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        var mutableRequest = urlRequest
        let fullPath = self.baseURL.absoluteString + self.path
        
        let authHeader = self.oauth.authHeader(method: self.method, url: fullPath, params: self.parameters as? [String: Any])
        mutableRequest.setValue(authHeader, forHTTPHeaderField: "Authorization")
        return mutableRequest
    }
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        return object
    }
}
