import PackageDescription

let package = Package(
    name: "SwiftyHaru",
    targets: [
        Target(name: "CLibPNG", dependencies: []),
        Target(name: "CLibHaru", dependencies: ["CLibPNG"]),
        Target(name: "SwiftyHaru", dependencies: ["CLibHaru"])
    ]
)
