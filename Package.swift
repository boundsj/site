// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "site",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0-rc.2"),
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0-rc.2.1.2"),
        .package(url: "https://github.com/vapor-community/markdown.git", .upToNextMajor(from: "0.4.0")),
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentSQLite", "Vapor", "Leaf", "SwiftMarkdown"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

