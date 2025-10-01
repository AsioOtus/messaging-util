// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swiftui-signal-util",
    platforms: [
        .iOS(.v15),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "SignalUtil",
            targets: ["SignalUtil"]),
    ],
    targets: [
        .target(
            name: "SignalUtil"
        )
    ]
)
