//
//  CharacterSet.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/20.
//

import Foundation

extension CharacterSet {
    public static var RFC3986: CharacterSet {
        return CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
    }
}
