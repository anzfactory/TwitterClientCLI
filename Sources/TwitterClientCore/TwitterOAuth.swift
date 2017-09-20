//
//  TwitterOAuth.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/20.
//

import Foundation

import APIKit
import CommonCrypto

final class TwitterOAuth {
    
    enum URLs {
        case authorize(oauthToken: String)
        
        var string: String {
            switch self {
            case .authorize(let oauthToken):
                return "https://api.twitter.com/oauth/authenticate?oauth_token=\(oauthToken)"
            }
        }
    }
    
    private let consumerKey: String
    private let consumerSecret: String
    private var oauthToken: String?
    private var oauthTokenSecret: String?
    
    private var version: String {
        return "1.0"
    }
    
    private var signatureMethod: String {
        return "HMAC-SHA1"
    }
    
    init(consumerKey: String, consumerSecret: String, oauthToken: String?, oauthTokenSecret: String?) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
        self.oauthToken = oauthToken
        self.oauthTokenSecret = oauthTokenSecret
    }
    
    func authHeader(method: APIKit.HTTPMethod, url: String, params: [String: Any]?) -> String {
        var authParmas = [String: Any]()
        authParmas["oauth_version"] = self.version
        authParmas["oauth_signature_method"] = self.signatureMethod
        authParmas["oauth_consumer_key"] = self.consumerKey
        authParmas["oauth_timestamp"] = String(Int(Date().timeIntervalSince1970))
        let uuid = NSUUID().uuidString
        authParmas["oauth_nonce"] = uuid.substring(to: uuid.index(uuid.startIndex, offsetBy: 8))
        
        if let key = self.oauthToken, !key.isEmpty {
            authParmas["oauth_token"] = key
        }
        
        for (key, value) in params ?? [:] {
            if key.hasPrefix("oauth_") {
                authParmas[key] = value
            }
        }
        
        var requestParams = authParmas
        for (key, value) in params ?? [:] {
            requestParams[key] = value
        }
        
        authParmas["oauth_signature"] = self.signature(method: method, url: url, params: requestParams)
        var authParamsArray = authParmas.encodeRFC3986().joinKeyValue(unionString: "=")
        authParamsArray.sort(by: { (arg1, arg2) -> Bool in
            return arg1 < arg2
        })
        
        let headerString = "OAuth \(authParamsArray.joined(separator: ", "))"
        return headerString
    }
    
    
    func signature(method: APIKit.HTTPMethod, url: String, params: [String: Any]?) -> String {
        var signatureKey = self.consumerSecret.addingPercentEncoding(withAllowedCharacters: .RFC3986)! + "&"
        if let secret = self.oauthTokenSecret, !secret.isEmpty {
            signatureKey += secret.addingPercentEncoding(withAllowedCharacters: .RFC3986)!
        }
        let encordedParams = params?.encodeRFC3986()
        var encordedParamsArray = encordedParams?.joinKeyValue(unionString: "=")
        encordedParamsArray?.sort(by: { (arg1, arg2) -> Bool in
            return arg1 < arg2
        })
        
        let paramString = encordedParamsArray?.joined(separator: "&")
        let encordedParamString = paramString?.addingPercentEncoding(withAllowedCharacters: .RFC3986)!
        let encordedUrl = url.addingPercentEncoding(withAllowedCharacters: .RFC3986)!
        let signatureBase = "\(method.rawValue)&\(encordedUrl)&\(encordedParamString ?? "")"
        let result = hmac(base: signatureBase, key: signatureKey).base64EncodedString(options: [])
        
        return result
    }
    
    func update(by requestToken: RequestToken) {
        self.oauthToken = requestToken.oauthToken
        self.oauthTokenSecret = requestToken.oauthTokenSecret
    }
    
    func update(by accessToken: AccessToken) {
        self.oauthToken = accessToken.oauthToken
        self.oauthTokenSecret = accessToken.oauthTokenSecret
    }
}

func hmac(base: String, key: String) -> NSData {
    let str = base.cString(using: .utf8)
    let strLen = UInt(base.lengthOfBytes(using: .utf8))
    let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
    let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
    let keyStr = key.cString(using: .utf8)
    let keyLen = UInt(key.lengthOfBytes(using: .utf8))
    
    CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), keyStr!, Int(keyLen), str!, Int(strLen), result)
    
    return NSData(bytes: result, length: digestLen)
}
