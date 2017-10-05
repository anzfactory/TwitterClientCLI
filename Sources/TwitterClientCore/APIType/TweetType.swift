//
//  TweetType.swift
//  Spectre
//
//  Created by shingo asato on 2017/09/20.
//

import Foundation

import APIKit

struct TweetType: TwitterAPIType {
    typealias Response = Tweet
    
    var oauth: TwitterOAuth
    var message: String
    var replyId: Int?
    var mediaId: Int?
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/1.1/statuses/update.json"
    }
    
    var parameters: Any? {
        var params: [String: Any] = ["status": self.message]
        if let replyId = self.replyId, replyId > 0 {
            params["in_reply_to_status_id"] = replyId
        }
        if let mediaId = self.mediaId, mediaId > 0 {
            params["media_ids"] = "\(mediaId)"
        }
        return params
    }
    
    var bodyParameters: BodyParameters? {
        if let params = self.parameters as? [String: Any] {
            return CustomFormURLEncodedBodyParameters(formObject: params, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Tweet {
        return try Tweet(object)
    }
}


public struct CustomFormURLEncodedBodyParameters: BodyParameters {
    public let form: [String: Any]
    
    public let encoding: String.Encoding
    
    public init(formObject: [String: Any], encoding: String.Encoding = .utf8) {
        self.form = formObject
        self.encoding = encoding
    }
    
    // MARK: - BodyParameters
    
    public var contentType: String {
        return "application/x-www-form-urlencoded"
    }
    
    public func buildEntity() throws -> RequestBodyEntity {
        // APIKitが内部で行っているエンコードとこっちでシグネチャ周りで行っているエンコードが違っているからかなのか
        // まるっと任せると スラッシュとかがツイート文に入っているとエラーになってしまうので、
        // 同じエンコードメソッドを使ってDataを作るようにしている...
        // 詳細をきっちりは追っていないけどこれでできるのでいいっしょ...。うん。😇
        let string = self.form.encodeRFC3986().joinKeyValue(unionString: "=").joined(separator: "&")
        return .data(string.data(using: .utf8, allowLossyConversion: true)!)
    }
}
