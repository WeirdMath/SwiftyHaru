// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "SwiftyHaru",
    targets: [
        Target(name: "CLibPNG"),
        Target(name: "CLibHaru", dependencies: ["CLibPNG"]),
        Target(name: "SwiftyHaru", dependencies: ["CLibHaru"])
    ]
)
