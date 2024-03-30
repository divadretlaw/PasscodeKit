//
//  Configuration.swift
//  PasscodeCore
//
//  Created by David Walter on 02.09.23.
//

import SwiftUI
import UIKit

public extension PasscodeEnvironmentValues {
    /// The duration of the dismiss animation.
    var animatedDismissDuration: TimeInterval {
        get { self[AnimatedDismissDurationKey.self] }
        set { self[AnimatedDismissDurationKey.self] = newValue }
    }
    
    /// The `ColorScheme` of the passcode overlay.
    var colorScheme: ColorScheme? {
        get { self[ColorSchemeKey.self] }
        set { self[ColorSchemeKey.self] = newValue }
    }
    
    /// The `UIWindow.Level` of the passcode overlay.
    ///
    /// > Info: Defaults to `UIWindow.Level.passcode`
    ///
    /// If you need the passcode window to be at a higher (or lower) level
    /// simply set this to the desired `UIWindow.Level`
    var windowLevel: UIWindow.Level {
        get { self[UIWindowLevelKey.self] }
        set { self[UIWindowLevelKey.self] = newValue }
    }
}

private struct AnimatedDismissDurationKey: EnvironmentKey {
    static var defaultValue: TimeInterval { 0.3 }
}

private struct ColorSchemeKey: EnvironmentKey {
    static var defaultValue: ColorScheme? { nil }
}

private struct UIWindowLevelKey: EnvironmentKey {
    static var defaultValue: UIWindow.Level { .passcode }
}
