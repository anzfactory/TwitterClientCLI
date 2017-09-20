//
//  Tweets.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/21.
//

import Foundation

import APIKit

struct Tweets {
    let list: [Tweet]
    
    init(_ object: Any) throws {
        guard let list = object as? Array<Dictionary<String, Any>> else {
            throw ResponseError.unexpectedObject("unknown...")
        }
        
        var tmp = [Tweet]()
        for item in list {
            tmp.append(try Tweet(item))
        }
        self.list = tmp
    }
}
