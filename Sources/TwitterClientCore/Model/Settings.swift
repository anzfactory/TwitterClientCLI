//
//  Settings.swift
//  Spectre
//
//  Created by shingo asato on 2017/10/05.
//

import Foundation

import APIKit
import Rainbow

struct Settings {
    let screenName: String
    let lang: String
    
    init(_ object: Any) throws {
        guard let dictionary = object as? [String: Any],
            let name = dictionary["screen_name"] as? String,
            let lang = dictionary["language"] as? String else {
                throw ResponseError.unexpectedObject(object)
        }
        self.screenName = name
        self.lang = lang
    }
}

extension Settings: Outputable {
    func output() -> String {
        return (screenName + " - " + lang).blue
    }
}
