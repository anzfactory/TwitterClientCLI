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
}

main.run()
