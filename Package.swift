// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "SwiftyHaru",
    products: [
        .library(name: "SwiftyHaru", targets: ["SwiftyHaru"])
    ],
    dependencies: [
       
    ],
    targets: [
       .systemLibrary(name: "CPNG", path: "Library/CPNG", pkgConfig: "libpng", providers: [ .brew(["libpng"]), .apt(["libpng"])]),
        .target(name: "CLibHaru", dependencies: [ "CPNG"]),
        .target(name: "SwiftyHaru", dependencies: ["CLibHaru"]),
 
    ]
)
