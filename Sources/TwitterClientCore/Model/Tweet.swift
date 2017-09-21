//
//  Tweet.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/20.
//

import Foundation

import APIKit

struct Tweet: Outputable {
    let id: Int
    let text: String
    let user: User
    
    init(_ object: Any) throws {
        guard let dictionary = object as? [String: Any],
            let id = dictionary["id"] as? Int,
            let userDictionary = dictionary["user"] as? [String: Any],
            let text = dictionary["text"] as? String else {
                throw ResponseError.unexpectedObject(object)
        }
        self.id = id
        self.text = text
        self.user = try User(userDictionary)
    }
    
    func output() -> String {
        return "@\(self.user.screenName) : \(self.id)\n\(self.text)"
    }
}
