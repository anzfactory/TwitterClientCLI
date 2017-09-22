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
    
    $0.command(
        "timeline",
        Option("count", 30, description: "取得するツイート数"),
        Option("since", 0, description: "以降のツイートID"),
        Option("max", 0, description: "以前のツイートID"),
        { (count, since, max) in
            let client = Client()
            client.timeline(count: count, sinceId: since, maxId: max)
        }
    )
    
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
    
    $0.command("unfavo") { (tweetId: Int) in
        let client = Client()
        client.unfavorite(tweetId)
    }
    
    $0.command(
        "search",
        Option("q", "", description: "検索するキーワード"),
        Option("u", "", description: "検索するユーザ名"),
        Option("count", 30, description: "検索する取得件数"),
        Option("since", 0, description: "以降のツイートID"),
        Option("max", 0, description: "以前のツイートID"),
        { (q, u, count, since, max) in
            let client = Client()
            if !q.isEmpty {
                client.searchTweet(q, count: count, sinceId: since, maxId: max)
            } else if !u.isEmpty {
                client.searchUser(u, count: count)
            }
        }
    )
    
    $0.command("follow",
               Option("id", 0, description: "フォローするユーザID"),
               Option("name", "", description: "フォローするユーザ名"), { (id, name) in
        let client = Client()
        client.follow(userId: id, screenName: name)
    })
    
    $0.command("unfollow",
               Option("id", 0, description: "フォローするユーザID"),
               Option("name", "", description: "フォローするユーザ名"), { (id, name) in
                let client = Client()
                client.unfollow(userId: id, screenName: name)
    })

}

main.run()
