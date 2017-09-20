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



