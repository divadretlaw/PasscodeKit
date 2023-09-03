//
//  Passcode.swift
//  PasscodeKit
//
//  Created by David Walter on 13.08.23.
//

import Foundation
import LocalAuthentication

/// A type that represents a passcode
public struct Passcode: Equatable, Hashable, Codable {
    /// The code of the passcode
    public var code: String
    /// The type of the passcode
    public var type: PasscodeType

    private var allowBiometrics: Bool?
    
    /// Create a new ``Passcode``
    ///
    /// - Parameters:
    ///   - code: The code to use.
    ///   - type: The type of the passcode.
    ///   - allowBiometrics: Whether the passcode allows biometrics.
    public init(_ code: String, type: PasscodeType, allowBiometrics: Bool = true) {
        self.code = code
        self.type = type
        self.allowBiometrics = allowBiometrics
    }
    
    /// Checks if the code is empty.
    public var isEmpty: Bool {
        code.isEmpty
    }
    
    /// Checks if the passcode is able to autocomplete
    public var canAutocomplete: Bool {
        switch type {
        case .numeric:
            return true
        case .customNumeric, .alphanumeric:
            return false
        }
    }
    
    /// Checks if the passcode is complete
    ///
    /// Only works if ``canAutocomplete`` is also `true`
    ///
    /// - Returns: Whether the code is complete
    public var isComplete: Bool? {
        switch type {
        case let .numeric(count):
            return code.count == count
        case .customNumeric, .alphanumeric:
            return nil
        }
    }
    
    /// Checks if biometrics are enabled
    public var isBiometricsEnabled: Bool {
        guard allowBiometrics == true else { return false }
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
}
