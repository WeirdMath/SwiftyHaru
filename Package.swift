// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "SwiftyHaru",
    targets: [
        Target(name: "CLibHaru"),
        Target(name: "SwiftyHaru", dependencies: ["CLibHaru"])
    ],
    dependencies: [
        .Package(url: "https://github.com/jessesquires/DefaultStringConvertible.git", majorVersion: 2),
        .Package(url: "https://github.com/WeirdMath/CZlib.git", majorVersion: 0),
        .Package(url: "https://github.com/WeirdMath/CLibPNG.git", majorVersion: 0)
    ]
)
