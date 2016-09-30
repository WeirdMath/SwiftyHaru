import PackageDescription

let package = Package(
    name: "SwiftyHaru",
    dependencies: [
        .Package(url: "https://github.com/WeirdMath/CLibHaru.git", majorVersion: 1)
    ]
)
