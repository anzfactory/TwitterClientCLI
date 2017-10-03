//
//  MediaUploadType.swift
//  Spectre
//
//  Created by shingo asato on 2017/10/03.
//

import Foundation

import APIKit

struct MediaUploadType: TwitterAPIType {
    typealias Response = Media
    
    var oauth: TwitterOAuth
    var url: URL
    
    var method: HTTPMethod {
        return .post
    }
    
    var baseURL: URL {
        return URL(string: "https://upload.twitter.com")!
    }
    
    var path: String {
        return "/1.1/media/upload.json"
    }
    
    var parameters: Any? {
        return nil
    }
    
    var bodyParameters: BodyParameters? {
        do {
            return MultipartFormDataBodyParameters(parts: [try MultipartFormDataBodyParameters.Part(fileURL: self.url, name: "media")])
        } catch {
            return nil
        }
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Media {
        return try Media(object)
    }
}
