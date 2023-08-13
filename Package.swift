// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "PasscodeKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "PasscodeKit",
            targets: ["PasscodeKit"]
        ),
        .library(
            name: "PasscodeCore",
            targets: ["PasscodeCore"]
        ),
        .library(
            name: "PasscodeModel",
            targets: ["PasscodeModel"]
        ),
        .library(
            name: "PasscodeUI",
            targets: ["PasscodeUI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/divadretlaw/WindowSceneReader.git", from: "2.0.0"),
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "20.0.0"),
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "0.10.0")
    ],
    targets: [
        .target(
            name: "PasscodeKit",
            dependencies: [
                "PasscodeCore",
                "PasscodeUI",
                .product(name: "KeychainSwift", package: "keychain-swift")
            ]
        ),
        .target(
            name: "PasscodeCore",
            dependencies: ["WindowSceneReader"]
        ),
        .target(
            name: "PasscodeModel",
            dependencies: []
        ),
        .target(
            name: "PasscodeUI",
            dependencies: [
                "PasscodeModel",
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
            ],
            resources: [.process("Resources")]
        )
    ]
)
