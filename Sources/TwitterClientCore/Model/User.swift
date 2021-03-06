//
//  User.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/21.
//

import Foundation

import APIKit
import Rainbow

struct User: Outputable {
    let id: Int
    let screenName: String
    let name: String
    let description: String
    let url: String
    let isFollowing: Bool
    
    init(_ object: Any) throws {
        guard let dictionary = object as? [String: Any],
            let id = dictionary["id"] as? Int,
            let screenName = dictionary["screen_name"] as? String else {
                throw ResponseError.unexpectedObject(object)
        }
        self.id = id
        self.screenName = screenName
        self.name = dictionary["name"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.url = dictionary["url"] as? String ?? ""
        self.isFollowing = dictionary["following"] as? Bool ?? false
    }
    
    func output() -> String {
        var string = "\(self.id) - \(self.screenName)"
        if !self.name.isEmpty {
            string += " : \(self.name)"
        }
        string = string.bold.underline
        if !self.description.isEmpty {
            string += "\n\(self.description)"
        }
        if !self.url.isEmpty {
            string += "\n\(self.url)".lightMagenta
        }
        return string
    }
}
