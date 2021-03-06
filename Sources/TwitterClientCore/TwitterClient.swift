import AppKit
import Foundation
import Dispatch

import APIKit
import Swiftline
import Rainbow

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
                NSWorkspace.shared.open(URL(string: TwitterOAuth.URLs.authorize(oauthToken: requestToken.oauthToken).string)!)
                
                let pinCode = ask("Enter PIN")
                
                self?.getAccessToken(pinCode: pinCode)
                
            case .failure(let error):
                print(error.localizedDescription.red)
                exit(0)
            }
            
        }
        dispatchMain()
    }
    
    public func logout() {
        UserDefaults.standard.removeObject(forKey: "oauthtoken")
        UserDefaults.standard.removeObject(forKey: "oauthtokensecret")
        print("アクセストークンをクリアしました\nアプリ連携の解除は忘れずに行って下さい".blue)
    }
    
    public func tweet(_ message: String, replyId: Int, path: String) {
        if message.isEmpty && path.isEmpty {
            print("message and path is empty...".red)
            return
        }
        
        self.getTweet(tweetId: replyId) { tweet in
            var msg = message
            if let tweet = tweet {
                msg = "@\(tweet.user.screenName) \(message)"
            }
            
            self.uploadMedia(path: path, callback: { mediaId in
                let request = TweetType(oauth: self.oauth, message: msg, replyId: replyId, mediaId: mediaId)
                Session.send(request) { [weak self] result in
                    switch result {
                    case .success(let tweet):
                        print("-- done --".blue)
                        self?.output(items: [tweet])
                    case .failure(let error):
                        print(error.localizedDescription.red)
                    }
                    exit(0)
                }
            })
        }
        
        dispatchMain()
    }
    
    public func retweet(_ tweetId: Int) {
        let request = RetweetType(oauth: self.oauth, tweetId: tweetId)
        Session.send(request) { [weak self] result in
            switch result {
            case .success(let tweet):
                print("-- retweeted --".blue)
                self?.output(items: [tweet])
            case .failure(let error):
                print(error.localizedDescription.red)
            }
            exit(0)
        }
        dispatchMain()
    }
    
    public func unretweet(_ tweetId: Int) {
        let request = UnRetweetType(oauth: self.oauth, tweetId: tweetId)
        Session.send(request) { [weak self] result in
            switch result {
            case .success(let tweet):
                print("-- unretweeted --".blue)
                self?.output(items: [tweet])
            case .failure(let error):
                print(error.localizedDescription.red)
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
                self?.output(items: tweets.list)
            case .failure(let error):
                print(error.localizedDescription.red)
            }
            exit(0)
        }
        dispatchMain()
    }
    
    public func favorite(_ tweetId: Int) {
        let request = FavoriteType(oauth: self.oauth, tweetId: tweetId)
        Session.send(request) { [weak self] result in
            switch result {
            case .success(let tweet):
                print("-- favorited --".blue)
                self?.output(items: [tweet])
            case .failure(let error):
                print(error.localizedDescription.red)
            }
            exit(0)
        }
        dispatchMain()
    }
    
    public func unfavorite(_ tweetId: Int) {
        let request = UnFavoriteType(oauth: self.oauth, tweetId: tweetId)
        Session.send(request) { [weak self] result in
            switch result {
            case .success(let tweet):
                print("-- unfavorited --".blue)
                self?.output(items: [tweet])
            case .failure(let error):
                print(error.localizedDescription.red)
            }
            exit(0)
        }
        dispatchMain()
    }
    
    public func love(_ tweetId: Int) {
        let request = FavoriteType(oauth: self.oauth, tweetId: tweetId)
        Session.send(request) {
            switch $0 {
            case .success(_):
                let retweetRequest = RetweetType(oauth: self.oauth, tweetId: tweetId)
                Session.send(retweetRequest) { [weak self] result in
                    switch result {
                    case .success(let tweet):
                        print("-- retweeted & favorited --".blue)
                        self?.output(items: [tweet])
                    case .failure(let error):
                        print(error.localizedDescription.red)
                    }
                    exit(0)
                }
            case .failure(let error):
                print(error.localizedDescription.red)
                exit(0)
            }
        }
        dispatchMain()
    }
    
    public func timeline(count: Int = 30, sinceId: Int = 0, maxId: Int = 0) {
        var count = count
        if count <= 0 {
            print("invalid count...".red)
            return
        } else if count > 200 {
            count = 200
        }
        
        let request = TimelineType(oauth: self.oauth, count: count, sinceId: sinceId, maxId: maxId)
        Session.send(request) { [weak self] result in
            switch result {
            case .success(let tweets):
                self?.output(items: tweets.list)
            case.failure(let error):
                print(error.localizedDescription.red)
            }
            exit(0)
        }
        dispatchMain()
    }
    
    public func userTimeline(_ screenName: String, count: Int = 30, sinceId: Int = 0, maxId: Int = 0) {
        var count = count
        if count <= 0 {
            print("invalid count...".red)
            return
        } else if count > 200 {
            count = 200
        }
        
        let request = UserTimelineType(oauth: self.oauth, screenName: screenName, count: count, sinceId: sinceId, maxId: maxId)
        Session.send(request) { [weak self] result in
            switch result {
            case .success(let tweets):
                self?.output(items: tweets.list)
            case.failure(let error):
                print(error.localizedDescription.red)
            }
            exit(0)
        }
        dispatchMain()
    }
    
    public func searchTweet(_ q: String, count: Int = 30, sinceId: Int, maxId: Int) {
        var count = count
        if count <= 0 {
            print("invalid count...".red)
            return
        } else if count > 200 {
            count = 200
        }
        
        let request = SearchTweetType(oauth: self.oauth, q: q, count: count, sinceId: sinceId, maxId: maxId)
        Session.send(request) { [weak self] result in
            switch result {
            case .success(let tweets):
                self?.output(items: tweets.list)
            case .failure(let error):
                print(error.localizedDescription.red)
            }
            exit(0)
        }
        dispatchMain()
    }
    
    public func searchUser(_ q: String, count: Int = 30) {
        var count = count
        if count <= 0 {
            print("invalid count...".red)
            return
        } else if count > 200 {
            count = 200
        }
        
        let request = SearchUserType(oauth: self.oauth, q: q, count: count)
        Session.send(request) { [weak self] result in
            switch result {
            case .success(let users):
                self?.output(items: users.list)
            case .failure(let error):
                print(error.localizedDescription.red)
            }
            exit(0)
        }
        dispatchMain()
    }
    
    public func follow(userId: Int, screenName: String) {
        let request = FollowType(oauth: self.oauth, userId: userId, screenName: screenName)
        Session.send(request) {
            switch $0 {
            case .success(let user):
                print("follow: @\(user.screenName)（\(user.id)）".blue)
            case .failure(let error):
                print(error.localizedDescription.red)
            }
            exit(0)
        }
        dispatchMain()
    }
    
    public func unfollow(userId: Int, screenName: String) {
        let request = UnFollowType(oauth: self.oauth, userId: userId, screenName: screenName)
        Session.send(request) {
            switch $0 {
            case .success(let user):
                print("unfollow: @\(user.screenName)（\(user.id)）".blue)
            case .failure(let error):
                print(error.localizedDescription.red)
            }
            exit(0)
        }
        dispatchMain()
    }
    
    public func me() {
        let request = AccountSettingsType(oauth: self.oauth)
        Session.send(request) { [weak self] result in
            switch result {
            case .success(let settings):
                self?.output(items: [settings])
            case .failure(let error):
                print(error.localizedDescription.red)
            }
            exit(0)
        }
        dispatchMain()
    }
    
    public func rateLimit() {
        let request = RateLimitType(oauth: self.oauth)
        Session.send(request) { [weak self] result in
            switch result {
            case .success(let rateLimit):
                self?.output(items: [rateLimit])
            case .failure(let error):
                print(error.localizedDescription.red)
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
                print("Hello \(accessToken.userName)".blue)
            case .failure(let error):
                print(error.localizedDescription.red)
            }
            exit(0)
        }
    }
    
    fileprivate func uploadMedia(path: String, callback: @escaping (Int?) -> Void) {
        
        if path.isEmpty {
            callback(nil)
            return
        }
        
        let request = MediaUploadType(oauth: self.oauth, url: URL(fileURLWithPath: path))
        Session.send(request) {
            switch $0 {
            case .success(let media):
                callback(media.id)
            case .failure(_):
                callback(nil)
            }
        }
    }
    
    fileprivate func getTweet(tweetId: Int, callback: @escaping (Tweet?) -> Void) {
        
        if 0 >= tweetId {
            callback(nil)
            return
        }
        
        let request = ShowTweetType(oauth: self.oauth, tweetId: tweetId)
        Session.send(request) {
            switch $0 {
            case .success(let tweet):
                callback(tweet)
            case .failure(let error):
                print(error)
                callback(nil)
            }
        }
    }
    
    fileprivate func output(items: [Outputable]) {
        for item in items {
            print(item.output())
            print("")
        }
    }
}
