//
//  Environment.swift
//  PasscodeKit
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI
import KeychainSwift

public extension EnvironmentValues {
    /// The `KeychainSwift` instance to store and read the passcode from.
    var passcodeKeychain: KeychainSwift {
        get { self[PasscodeKeychainKey.self] }
        set { self[PasscodeKeychainKey.self] = newValue }
    }
    
    /// The `KeychainSwiftAccessOptions` option to use when storing the passcode.
    var passcodeKeychainAccessOption: KeychainSwiftAccessOptions? {
        get { self[PasscodeKeychainAccessOptionKey.self] }
        set { self[PasscodeKeychainAccessOptionKey.self] = newValue }
    }
    
    /// The key to use when storing and reading the passcode.
    var passcodeKey: String {
        get { self[PasscodeKeyKey.self] }
        set { self[PasscodeKeyKey.self] = newValue }
    }
    
    /// The background material to use when presenting the passcode view.
    var passcodeBackgroundMaterial: Material? {
        get { self[PasscodeBackgroundMaterialKey.self] }
        set { self[PasscodeBackgroundMaterialKey.self] = newValue }
    }
}

struct PasscodeKeychainKey: EnvironmentKey {
    static var defaultValue: KeychainSwift {
        KeychainSwift()
    }
}

struct PasscodeKeychainAccessOptionKey: EnvironmentKey {
    static var defaultValue: KeychainSwiftAccessOptions? {
        nil
    }
}

struct PasscodeKeyKey: EnvironmentKey {
    static var defaultValue: String {
        "PasscodeKit.Passcode"
    }
}

struct PasscodeBackgroundMaterialKey: EnvironmentKey {
    static var defaultValue: Material? {
        .regular
    }
}
