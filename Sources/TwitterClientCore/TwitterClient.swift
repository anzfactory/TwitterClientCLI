import AppKit
import Foundation
import Dispatch

import APIKit
import Swiftline

public final class Client {
    
    let oauth: TwitterOAuth = TwitterOAuth(
        consumerKey: Keys.consumerKey,
        consumerSecret: Keys.consumerSecret,
        oauthToken: UserDefaults.standard.string(forKey: "oauthtoken"),
        oauthTokenSecret: UserDefaults.standard.string(forKey: "oauthtokensecret")
    )
    
    public init() { }
}

extension Client {
    public func auth() {
        let request = RequestTokenType(oauth: self.oauth)
        Session.send(request) { [weak self] result in
            switch result {
            case .success(let requestToken):
                self?.oauth.update(by: requestToken)
                NSWorkspace.shared().open(URL(string: TwitterOAuth.URLs.authorize(oauthToken: requestToken.oauthToken).string)!)
                
                let pinCode = ask("Enter PIN")
                
                self?.getAccessToken(pinCode: pinCode)
                
            case .failure(let error):
                print(error)
                exit(0)
            }
            
        }
        dispatchMain()
    }
    
    public func logout() {
        UserDefaults.standard.removeObject(forKey: "oauthtoken")
        UserDefaults.standard.removeObject(forKey: "oauthtokensecret")
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
    
    public func retweet(_ tweetId: Int) {
        let request = RetweetType(oauth: self.oauth, tweetId: tweetId)
        Session.send(request) {
            switch $0 {
            case .success(let tweet):
                print("retweeted: \(tweet.id)")
            case .failure(let error):
                print(error)
            }
            exit(0)
        }
        dispatchMain()
    }
    
    public func unretweet(_ tweetId: Int) {
        let request = UnRetweetType(oauth: self.oauth, tweetId: tweetId)
        Session.send(request) {
            switch $0 {
            case .success(let tweet):
                print("unretweeted: \(tweet.id)")
            case .failure(let error):
                print(error)
            }
            exit(0)
        }
        dispatchMain()
    }
    
    public func favorites(count: Int = 30) {
        let request = FavoritesType(oauth: self.oauth, count: count)
        Session.send(request) { [weak self] result in
            switch result {
            case .success(let tweets):
                self?.outputTweets(tweets: tweets.list)
            case .failure(let error):
                print(error)
            }
            exit(0)
        }
        dispatchMain()
    }
    
    public func timeline(count: Int = 30) {
        var count = count
        if count <= 0 {
            print("invalid count...")
            return
        } else if count > 200 {
            count = 200
        }
        
        let request = TimelineType(oauth: self.oauth, count: count)
        Session.send(request) { [weak self] result in
            switch result {
            case .success(let tweets):
                self?.outputTweets(tweets: tweets.list)
            case.failure(let error):
                print(error)
            }
            exit(0)
        }
        dispatchMain()
    }
}

extension Client {
    fileprivate func getAccessToken(pinCode: String) {
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
    
    fileprivate func outputTweets(tweets: [Tweet]) {
        for tweet in tweets {
            print("@\(tweet.user.screenName) : \(tweet.id)\n\(tweet.text)\n----------")
        }
    }
}
