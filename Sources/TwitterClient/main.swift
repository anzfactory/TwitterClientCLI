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
    
}

main.run()
