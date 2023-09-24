// swift-tools-version: 5.6

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
        )
    ],
    dependencies: [
        .package(url: "https://github.com/divadretlaw/WindowSceneReader.git", from: "2.1.0"),
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "20.0.0"),
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "PasscodeKit",
            dependencies: [
                "PasscodeCore",
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
                .product(name: "KeychainSwift", package: "keychain-swift")
            ],
            resources: [.process("Resources")]
        ),
        .target(
            name: "PasscodeCore",
            dependencies: ["WindowSceneReader"]
        )
    ]
)
