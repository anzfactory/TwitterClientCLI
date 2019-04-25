// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "TwitterClientCLI",
    products: [
        .library(name: "twcli", targets: ["TwitterClient", "TwitterClientCore"]),
    ],
    dependencies: [
       .package(url: "https://github.com/kylef/Commander.git", from: "0.8.0"),
       .package(url: "https://github.com/ishkawa/APIKit.git", from: "5.0.0"),
       .package(url: "https://github.com/anzfactory/Swiftline.git", .branch("swift-tool-version-4.0")),
       .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.0.0"),
       .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "TwitterClient",
            dependencies: [
                "TwitterClientCore",
                "Commander",
                "Swiftline"
            ]
        ),
        .target(name: "TwitterClientCore", dependencies: [
            "APIKit",
            "CryptoSwift",
            "Rainbow"
        ])
    ]
)
