// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "messaging-util",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        .library(
            name: "MessagingUtil",
            targets: ["MessagingUtil"]),
    ],
    targets: [
        .target(
            name: "MessagingUtil"
        )
    ]
)
