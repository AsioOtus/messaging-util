// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swiftui-messaging-util",
    platforms: [
        .iOS(.v15),
        .macOS(.v11)
    ],
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
