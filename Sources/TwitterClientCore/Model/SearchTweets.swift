//
//  SearchTweets.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/21.
//

import Foundation

import APIKit

struct SearchTweets {
    let list: [Tweet]
    
    init(_ object: Any) throws {
        guard let dictionary = object as? Dictionary<String, Any>, let list = dictionary["statuses"] as? Array<Dictionary<String, Any>> else {
            print(object)
            throw ResponseError.unexpectedObject("unknown...")
        }
        
        var tmp = [Tweet]()
        for item in list {
            tmp.append(try Tweet(item))
        }
        self.list = tmp
    }

}
