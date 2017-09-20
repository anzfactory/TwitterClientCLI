//
//  Sequence.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/20.
//

import Foundation

extension Sequence where Iterator.Element == (key: String, value: Any) {
    func encodeRFC3986() -> Dictionary<String, Any> {
        
        var result = [String: String]()
        
        for (key, value) in self {
            if let keyString = "\(key)".addingPercentEncoding(withAllowedCharacters: .RFC3986),
                let valueString = "\(value)".addingPercentEncoding(withAllowedCharacters: .RFC3986) {
                result[keyString] = valueString
            }
        }
        
        return result
    }
    
    func joinKeyValue(unionString: String) -> Array<String> {
        var result = [String]()
        for (key, value) in self {
            result.append("\(key)\(unionString)\(value)")
        }
        return result
    }
}
