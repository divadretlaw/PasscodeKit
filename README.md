# PasscodeKit

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdivadretlaw%2FPasscodeKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/divadretlaw/PasscodeKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdivadretlaw%2FPasscodeKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/divadretlaw/PasscodeKit)

Easily add a passcode to your iOS app

## Usage

PasscodeKit is split into several modules and depending on what you need you can use different or multiple modules.

### PasscodeKit

<img width="200" alt="Screenshot" src="https://github.com/divadretlaw/PasscodeKit/assets/6899256/f9328b38-7b17-42b0-ab4b-3e07dad4f1d6">

The most complete, but also less customizable, module. Simply add `.passcode(title:hint:)`, with an optional title and hint view, to your root view.

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .passcode("Enter Passcode") {
                    // Optional view as a hint above the code view
                }
        }
    }
}
```

The passcode has to be setup by the user in order to be used, you can add this modifier to any view to start the setup.

```swift
.setupPasscode(isPresented: $setupPasscode, type: .numeric(6))
```

To remove the passcode again, use the environment variables to access the . You can also set the manager environment variable to override the used Keychain instance and key where the key that is used to store the data.

```swift
@Environment(\.passcodeManager) private var passcodeManager
```

Then simply remove the entry for the passcode

```swift
passcodeManager.delete()
```

### PasscodeCore

The core module, that handles displaying the passcode window. By default it has no UI to enter a passcode or setting up and storing the passcode, but you can use this to implement your own passcode UI.

```swift
.passcode(mode: PasscodeMode) { dismiss in
    // some Passcode input UI
} background: {
    // some optional background
}
```

### PasscodeUI

The UI used in `PasscodeKit` without dependencies on `PasscodeCore` and `PasscodeKit`

#### Localization

Customize / Localize the `PasscodeUI` by providing a `Passcode.strings` file in your main app bundle. See the default [Passcode.strings](Sources/PasscodeUI/Resources/Passcode.strings) file for English Strings.

## Installation

### Xcode

Add the following package URL to Xcode

```
https://github.com/divadretlaw/PasscodeKit
```

Select the module(s) you need

![Xcode](https://github.com/divadretlaw/PasscodeKit/assets/6899256/457e60c8-9146-4c57-bf2a-83f970b0e203)

### Swift Package Manager

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/divadretlaw/PasscodeKit.git", from: "0.3.0"),
    ],
    targets: [
        .target(
            name: <#Target Name#>,
            dependencies: [
                .product(name: "PasscodeKit", package: "PasscodeKit")
            ]
        )
    ]
)
```

## License

See [LICENSE](LICENSE)
