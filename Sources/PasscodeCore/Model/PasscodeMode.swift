//
//  PasscodeMode.swift
//  PasscodeCore
//
//  Created by David Walter on 12.08.23.
//

import Foundation

/// The behavior of the passcode view
public enum PasscodeMode: Int, Hashable, Equatable, Codable, Identifiable, Sendable {
    /// Only the provided background is visible in the app switcher.
    case hideInAppSwitcher
    /// The passcode input view is always visble.
    case alwaysVisible
    /// The passcode view will hide itself when re-entering the app.
    case autohide
    /// The passcode view will never appear.
    case disabled
    
    /// The default mode. The default mode is ``hideInAppSwitcher``
    public static var `default`: PasscodeMode { .hideInAppSwitcher }
    
    // MARK: - Sendable
    
    public var id: Int { rawValue }
}
