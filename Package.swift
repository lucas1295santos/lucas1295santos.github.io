// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Lucas1295santosGithubIo",
    products: [
        .executable(name: "Lucas1295santosGithubIo", targets: ["Lucas1295santosGithubIo"])
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.3.0")
    ],
    targets: [
        .target(
            name: "Lucas1295santosGithubIo",
            dependencies: ["Publish"]
        )
    ]
)