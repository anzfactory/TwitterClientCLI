import AppKit
import Foundation
import Dispatch

import APIKit
import Swiftline
import CommonCrypto

enum Endpoint {
    case requestAuthToken, pinCode(oauthToken: String)
    
    var url: String {
        switch self {
        case .requestAuthToken:
            return "https://api.twitter.com/oauth/request_token"
        case .pinCode(let oauthToken):
            return "https://api.twitter.com/oauth/authenticate?oauth_token=\(oauthToken)"
        }
    }
}

public final class Client {
    
    let oauth: TwitterOAuth = TwitterOAuth(
        consumerKey: "EJlJGgdgSok69NS1WdsRXobeU",
        consumerSecret: "Qnteu1i48SXmmxet3bGssvB8uvbGrR2XHkY3LebYbSDMeAHNCl",
        oauthToken: UserDefaults.standard.string(forKey: "oauthtoken"),
        oauthTokenSecret: UserDefaults.standard.string(forKey: "oauthtokensecret")
    )
    
    public init() { }
    
    public func auth() {
        let request = RequestTokenType(oauth: self.oauth)
        Session.send(request) { [weak self] result in
            switch result {
            case .success(let requestToken):
                self?.oauth.update(by: requestToken)
                NSWorkspace.shared().open(URL(string: Endpoint.pinCode(oauthToken: requestToken.oauthToken).url)!)
                
                let pinCode = ask("Enter PIN")
                
                self?.getAccessToken(pinCode: pinCode)
                
            case .failure(let error):
                print(error)
                exit(0)
            }
            
        }
        dispatchMain()
    }
    
    public func tweet(_ message: String?) {
        guard let message = message else {
            print("message is empty...")
            return
        }
        
        let request = TweetType(oauth: self.oauth, message: message)
        Session.send(request) {
            switch $0 {
            case .success(let tweet):
                print("done: \(tweet.id)")
            case .failure(let error):
                print(error)
            }
            exit(0)
        }
        dispatchMain()
    }
    
    public func logout() {
        UserDefaults.standard.removeObject(forKey: "oauthtoken")
        UserDefaults.standard.removeObject(forKey: "oauthtokensecret")
    }
    
    private func getAccessToken(pinCode: String) {
        let request = AccessTokenType(oauth: self.oauth, pinCode: pinCode)
        Session.send(request) { [weak self] result in
            switch result {
            case .success(let accessToken):
                UserDefaults.standard.set(accessToken.oauthToken, forKey: "oauthtoken")
                UserDefaults.standard.set(accessToken.oauthTokenSecret, forKey: "oauthtokensecret")
                self?.oauth.update(by: accessToken)
                print("Hello \(accessToken.userName)")
            case .failure(let error):
                print(error)
            }
            exit(0)
        }
    }
}


public final class TwitterOAuth {
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


extension CharacterSet {
    public static var RFC3986: CharacterSet {
//        return CharacterSet(charactersIn: "!:/?&=;+@#$()',*").inverted
        return CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
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

// API Kit

protocol TwitterApiType: Request {
    var oauth: TwitterOAuth { get }
}

extension TwitterApiType {
    
    var baseURL: URL {
        return URL(string: "https://api.twitter.com")!
    }
    
    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        var mutableRequest = urlRequest
        let fullPath = self.baseURL.absoluteString + self.path
        
        let authHeader = self.oauth.authHeader(method: self.method, url: fullPath, params: self.parameters as? [String: Any])
        mutableRequest.setValue(authHeader, forHTTPHeaderField: "Authorization")
        return mutableRequest
    }
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        return object
    }
}

struct RequestTokenType: TwitterApiType {
    typealias Response = RequestToken
    
    var oauth: TwitterOAuth
    
    var method: HTTPMethod {
        return .post
    }
    
    var dataParser: DataParser {
        return FormURLEncodedDataParser(encoding: .utf8)
    }
    
    var path: String {
        return "/oauth/request_token"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> RequestToken {
        return try RequestToken(object)
    }
    
}

struct RequestToken {
    let oauthToken: String
    let oauthTokenSecret: String
    
    init(_ object: Any) throws {
        guard let dictionary = object as? [String: Any],
            let oauthToken = dictionary["oauth_token"] as? String,
            let oauthTokenSecret = dictionary["oauth_token_secret"] as? String else {
            throw ResponseError.unexpectedObject(object)
        }
        self.oauthToken = oauthToken
        self.oauthTokenSecret = oauthTokenSecret
    }
}

struct AccessTokenType: TwitterApiType {
    typealias Response = AccessToken
    
    var oauth: TwitterOAuth
    var pinCode: String
    
    var method: HTTPMethod {
        return .post
    }
    
    var dataParser: DataParser {
        return FormURLEncodedDataParser(encoding: .utf8)
    }
    
    var path: String {
        return "/oauth/access_token"
    }
    
    var parameters: Any? {
        return ["oauth_verifier": self.pinCode]
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> AccessToken {
        return try AccessToken(object)
    }
}

struct AccessToken {
    let oauthToken: String
    let oauthTokenSecret: String
    let userName: String
    
    init(_ object: Any) throws {
        guard let dictionary = object as? [String: Any],
            let oauthToken = dictionary["oauth_token"] as? String,
            let oauthTokenSecret = dictionary["oauth_token_secret"] as? String,
            let userName = dictionary["screen_name"] as? String else {
                throw ResponseError.unexpectedObject(object)
        }
        self.oauthToken = oauthToken
        self.oauthTokenSecret = oauthTokenSecret
        self.userName = userName
    }
}

struct TweetType: TwitterApiType {
    typealias Response = Tweet
    
    var oauth: TwitterOAuth
    var message: String
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/1.1/statuses/update.json"
    }
    
    var parameters: Any? {
        return ["status": self.message]
    }

    var bodyParameters: BodyParameters? {
        if let params = self.parameters as? [String: Any] {
            return FormURLEncodedBodyParameters(formObject: params, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Tweet {
        return try Tweet(object)
    }
}

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
