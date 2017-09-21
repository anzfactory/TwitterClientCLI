import TwitterClientCore
import Commander

let main = Group {
    $0.command("auth") {
        let client = Client()
        client.auth()
    }
    
    $0.command("tweet") { (message: String) in
        let client = Client()
        client.tweet(message)
    }
    
    $0.command("logout") {
        let client = Client()
        client.logout()
    }
    
    $0.command("timeline", Option("count", 30, description: "取得するツイート数"), { count in
        let client = Client()
        client.timeline(count: count)
    })
    
    $0.command("retweet") { (tweetId: Int) in
        let client = Client()
        client.retweet(tweetId)
    }
    
    $0.command("unretweet") { (tweetId: Int) in
        let client = Client()
        client.unretweet(tweetId)
    }
    
    $0.command("favolist", Option("count", 30, description: "取得するいいね済みツイート数"), { count in
        let client = Client()
        client.favorites(count: count)
    })
    
    $0.command("favo") { (tweetId: Int) in
        let client = Client()
        client.favorite(tweetId)
    }

}

main.run()
