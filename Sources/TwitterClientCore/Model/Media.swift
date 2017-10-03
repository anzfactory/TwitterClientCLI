//
//  Media.swift
//  Spectre
//
//  Created by shingo asato on 2017/10/03.
//

import Foundation

import APIKit

struct Media {
    let id: Int
    let size: Int
    let type: String
    let width: Int
    let height: Int
    
    init(_ object: Any) throws {
        guard let dictionary = object as? [String: Any],
            let id = dictionary["media_id"] as? Int,
            let size = dictionary["size"] as? Int,
            let meta = dictionary["image"] as? [String: Any] else {
                throw ResponseError.unexpectedObject(object)
        }
        self.id = id
        self.size = size
        self.type = meta["image_type"] as? String ?? ""
        self.width = meta["w"] as? Int ?? 0
        self.height = meta["h"] as? Int ?? 0
    }
    
}
