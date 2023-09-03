//
//  PasscodeManager.swift
//  PasscodeKit
//
//  Created by David Walter on 01.09.23.
//

import SwiftUI
import PasscodeCore
import KeychainSwift

/// Manage the passcode of your app
public final class PasscodeManager {
    /// The key of the stored passcode item in the keychain.
    public private(set) var key: String
    /// The keychain implementation where the passcode item is stored in.
    public private(set) var keychain: KeychainSwift
    /// These options are used to determine when the passcode item should be readable.
    private var keychainAccess: KeychainSwiftAccessOptions?
    
    public init(
        key: String = "PasscodeKit.Passcode",
        keychain: KeychainSwift = KeychainSwift(),
        access: KeychainSwiftAccessOptions? = nil
    ) {
        self.key = key
        self.keychain = keychain
    }
    
    /// The passcode or `nil` if none is set.
    public var passcode: Passcode? {
        do {
            guard let data = keychain.getData(key) else { return nil }
            return try JSONDecoder().decode(Passcode.self, from: data)
        } catch {
            return nil
        }
    }
    
    /// Checks if the passcode is setup.
    public var isSetup: Bool {
        keychain.get(key) != nil
    }
    
    /// Sets a new passcode
    ///
    /// - Parameters:
    ///   - code: The code of the passcode.
    ///   - type: The type of the code.
    ///   - allowBiometrics: Whether to allow biometrics or not.
    /// - Returns: True if the passcode was successfully stored.
    public func setPasscode(code: String, type: PasscodeType, allowBiometrics: Bool) -> Bool {
        let passcode = Passcode(code, type: type, allowBiometrics: allowBiometrics)
        return setPasscode(passcode)
    }
    
    /// Sets a new passcode
    ///
    /// - Parameters:
    ///   - passcode: The passcode to set.
    /// - Returns: True if the passcode was successfully stored.
    public func setPasscode(_ passcode: Passcode) -> Bool {
        do {
            let data = try JSONEncoder().encode(passcode)
            keychain.set(data, forKey: key, withAccess: keychainAccess)
            return true
        } catch {
            return false
        }
    }
    
    /// Enabled (or disables) biometrics on the current passcode.
    ///
    /// - Parameters:
    ///     - enabled: Whether to allow biometrics or not.
    /// - Returns: True if the passcode was successfully stored.
    @discardableResult public func setBiometrics(_ enabled: Bool) -> Bool {
        guard let passcode = passcode else { return false }
        return setPasscode(code: passcode.code, type: passcode.type, allowBiometrics: enabled)
    }
    
    /// Deletes the current passcode.
    ///
    /// - Returns: True if the passcode was successfully deleted.
    @discardableResult public func delete() -> Bool{
        keychain.delete(key)
    }
}

public extension PasscodeEnvironmentValues {
    /// The ``PasscodeManager`` to manage the passcode.
    var manager: PasscodeManager {
        get { self[PasscodeManagerKey.self] }
        set { self[PasscodeManagerKey.self] = newValue }
    }
}

struct PasscodeManagerKey: EnvironmentKey {
    static var defaultValue: PasscodeManager {
        PasscodeManager()
    }
}
