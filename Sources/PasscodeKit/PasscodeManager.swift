//
//  PasscodeManager.swift
//  PasscodeKit
//
//  Created by David Walter on 01.09.23.
//

import Foundation
import KeychainSwift
import PasscodeModel

public final class PasscodeManager {
    public private(set) var key: String
    public private(set) var keychain: KeychainSwift
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
    /// - Parameter enabled: Whether to allow biometrics or not.
    /// - Returns: True if the passcode was successfully stored.
    @discardableResult public func setBiometrics(_ enabled: Bool) -> Bool {
        guard let passcode = passcode else { return false }
        return setPasscode(code: passcode.code, type: passcode.type, allowBiometrics: enabled)
    }
    
    /// Deletes the current passcode.
    ///
    /// - Parameter enabled: Whether to allow biometrics or not.
    /// - Returns: True if the passcode was successfully deleted.
    @discardableResult public func delete() -> Bool{
        keychain.delete(key)
    }
}
