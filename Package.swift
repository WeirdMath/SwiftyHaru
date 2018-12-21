// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "SwiftyHaru",
    products: [
        .library(name: "SwiftyHaru", targets: ["SwiftyHaru"])
    ],
    targets: [
        .target(name: "CLibPNG"),
        .target(name: "CLibHaru", dependencies: ["CLibPNG"]),
        .target(name: "SwiftyHaru", dependencies: ["CLibHaru"]),
        .testTarget(name: "SwiftyHaruTests", dependencies: ["SwiftyHaru"])
    ]
)
