import TwitterClientCore
import Commander

let main = Group {
    $0.command("auth") {
        let client = Client()
        client.auth()
    }
    
    $0.command(
        "tweet",
        Argument<String>("message", description: "ツイート文"),
        Option("reply", 0, description: "返信するツイートID"),
        { (message, reply) in
            let client = Client()
            client.tweet(message, replyId: reply)
        }
    )
    
    $0.command("logout") {
        let client = Client()
        client.logout()
    }
    
    $0.command(
        "timeline",
        Option("count", 30, description: "取得するツイート数"),
        Option("since", 0, description: "以降のツイートID"),
        Option("max", 0, description: "以前のツイートID"),
        Option("user", "", description: "タイムラインを取得したいユーザのスクリーンネーム"),
        { (count, since, max, user) in
            let client = Client()
            if user.isEmpty {
                client.timeline(count: count, sinceId: since, maxId: max)
            } else {
                client.userTimeline(user, count: count, sinceId: since, maxId: max)
            }
            
        }
    )
    
    $0.command("retweet", Argument<Int>("tweetId", description: "リツイートするツイートID"), { (tweetId: Int) in
        let client = Client()
        client.retweet(tweetId)
    })
    
    $0.command("unretweet", Argument<Int>("tweetId", description: "リツイートを解除するツイートID"), { (tweetId: Int) in
        let client = Client()
        client.unretweet(tweetId)
    })
    
    $0.command("favolist", Option("count", 30, description: "取得するいいね済みツイート数"), { count in
        let client = Client()
        client.favorites(count: count)
    })
    
    $0.command("favo", Argument<Int>("tweetId", description: "いいねするツイートID"), { (tweetId: Int) in
        let client = Client()
        client.favorite(tweetId)
    })
    
    $0.command("unfavo", Argument<Int>("tweetId", description: "いいねを解除するツイートID"), { (tweetId: Int) in
        let client = Client()
        client.unfavorite(tweetId)
    })
    
    $0.command("love", Argument<Int>("tweetId", description: "リツイート＆いいねをするツイートID"), { tweetId in
        let client = Client()
        client.love(tweetId)
    })
    
    $0.command(
        "search",
        Argument<String>("keyword", description: "検索ワード"),
        Option("count", 30, description: "検索する取得件数"),
        Option("since", 0, description: "以降のツイートID"),
        Option("max", 0, description: "以前のツイートID"),
        Flag("fromUser", description: "検索するキーワード"),
        { (keyword, count, since, max, fromUser) in
            let client = Client()
            if fromUser {
                client.searchUser(keyword, count: count)
            } else {
                client.searchTweet(keyword, count: count, sinceId: since, maxId: max)
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
