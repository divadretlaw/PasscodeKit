//
//  Passcode.swift
//  PasscodeModel
//
//  Created by David Walter on 13.08.23.
//

import Foundation

/// Passcode
public struct Passcode: Equatable, Hashable, Codable {
    /// The code of the passcode
    public var code: String
    /// The type of the passcode
    public var type: PasscodeType
    
    public init(_ code: String, type: PasscodeType) {
        self.code = code
        self.type = type
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
}
