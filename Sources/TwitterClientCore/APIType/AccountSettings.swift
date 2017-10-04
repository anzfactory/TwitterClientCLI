//
//  AccountSettings.swift
//  Spectre
//
//  Created by shingo asato on 2017/10/05.
//

import Foundation

import APIKit

struct AccountSettingsType: TwitterAPIType {
    typealias Response = Settings
    
    var oauth: TwitterOAuth
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/1.1/account/settings.json"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Settings {
        return try Settings(object)
    }
}
