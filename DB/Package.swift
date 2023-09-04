// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DB",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "DB", targets: [
            "DB"
        ]),
        .library(name: "DBSwiftData", targets: [
            "DBSwiftData"
        ])
    ],
    targets: [
        .target(name: "DB"),
        .target(name: "DBSwiftData", dependencies: [
            "DB"
        ])
    ]
)
