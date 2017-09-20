//
//  User.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/21.
//

import Foundation

import APIKit

struct User {
    let id: Int
    let screenName: String
    
    init(_ object: Any) throws {
        guard let dictionary = object as? [String: Any],
            let id = dictionary["id"] as? Int,
            let screenName = dictionary["screen_name"] as? String else {
                throw ResponseError.unexpectedObject(object)
        }
        self.id = id
        self.screenName = screenName
    }
}
