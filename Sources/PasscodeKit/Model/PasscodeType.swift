//
//  PasscodeType.swift
//  PasscodeKit
//
//  Created by David Walter on 13.08.23.
//

import Foundation

/// Type of the passcode
public enum PasscodeType: Hashable, Equatable, Codable, Identifiable, Sendable {
    /// A fixed width numeric code
    case numeric(_ digits: Int)
    /// A custom width numeric code
    case customNumeric
    /// A custom width alphanumeric code
    case alphanumeric
    
    // MARK: - Helper
    
    /// Checks if the passcode is numeric
    public var isNumeric: Bool {
        switch self {
        case .numeric, .customNumeric:
            return true
        default:
            return false
        }
    }
    
    /// Checks if the passcode is alphanumeric
    public var isAlphaNumeric: Bool {
        switch self {
        case .alphanumeric:
            return true
        default:
            return false
        }
    }
    
    /// Checks if the passcode is able to autocomplete
    public var canAutoComplete: Bool {
        switch self {
        case .numeric:
            return true
        default:
            return false
        }
    }
    
    /// Returns the max. input length
    public var maxInputLength: Int {
        switch self {
        case let .numeric(count):
            return count
        case .customNumeric:
            return .max
        case .alphanumeric:
            return .max
        }
    }
    
    // MARK: - Identifiable
    
    public var id: String {
        switch self {
        case let .numeric(count):
            return "numeric.\(count)"
        case .customNumeric:
            return "numeric.custom"
        case .alphanumeric:
            return "alphaNumeric.custom"
        }
    }
}
