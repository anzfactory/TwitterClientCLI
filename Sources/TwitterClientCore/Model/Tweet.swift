//
//  Tweet.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/20.
//

import Foundation

import APIKit

struct Tweet {
    let id: Int
    let text: String
    
    init(_ object: Any) throws {
        guard let dictionary = object as? [String: Any],
            let id = dictionary["id"] as? Int,
            let text = dictionary["text"] as? String else {
                throw ResponseError.unexpectedObject(object)
        }
        self.id = id
        self.text = text
    }
}
