//
//  TwitterAPI.swift
//  TwitterClientCLI
//
//  Created by shingo asato on 2017/09/10.
//
//

import Foundation
import APIKit

final class TwitterAPI {
    func hoge() {
        print("aa")
    }
}

// Reauestのベース
protocol GithubRequest: Request { }

extension GithubRequest {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
}

// TODO 別ファイル
struct RateLimit {
    let count: Int
    let resetDate: TimeInterval
    
    init?(dictionary: [String: AnyObject]) {
        guard let count = dictionary["rate"]?["limit"] as? Int else {
            return nil
        }
        
        guard let resetDate = dictionary["rate"]?["reset"] as? TimeInterval else {
            return nil
        }
        
        self.count = count
        self.resetDate = resetDate
    }
}

// TODO 各エンドポイントのRequest
struct GetRateLimitRequest: GithubRequest {
    typealias Response = RateLimit
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/rate_limit"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let dictionary = object as? [String: AnyObject],
            let rateLimit = RateLimit(dictionary: dictionary) else {
            throw ResponseError.unexpectedObject(object)
        }
        
        return rateLimit
    }
}
