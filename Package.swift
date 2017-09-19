// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "TwitterClientCLI",
    targets: [
        Target(
            name: "TwitterClient",
            dependencies: ["TwitterClientCore"]
        ),
        Target(name: "TwitterClientCore")
    ],
    dependencies: [
       .Package(url: "https://github.com/kylef/Commander.git", majorVersion: 0),
       .Package(url: "https://github.com/ishkawa/APIKit.git", majorVersion: 3),
       .Package(url: "https://github.com/nsomar/Swiftline.git", majorVersion: 0),
       .Package(url: "https://github.com/venj/CommonCrypto.git", majorVersion: 0),
       .Package(url: "https://github.com/OAuthSwift/OAuthSwift.git", majorVersion: 1, minor: 1)
    ]
)
