//
//  Users.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/21.
//

import Foundation

import APIKit

struct Users {
    let list: [User]
    
    init(_ object: Any) throws {
        guard let list = object as? Array<Dictionary<String, Any>> else {
            throw ResponseError.unexpectedObject("unknown...")
        }
        
        var tmp = [User]()
        for item in list {
            tmp.append(try User(item))
        }
        self.list = tmp
    }
}
