//
//  Configuration.swift
//  PasscodeCore
//
//  Created by David Walter on 02.09.23.
//

import SwiftUI

public extension PasscodeEnvironmentValues {
    var animatedDismissDuration: TimeInterval {
        get { self[AnimatedDismissDurationKey.self] }
        set { self[AnimatedDismissDurationKey.self] = newValue }
    }
    
    var colorScheme: ColorScheme? {
        get { self[ColorSchemeKey.self] }
        set { self[ColorSchemeKey.self] = newValue }
    }
}

private struct AnimatedDismissDurationKey: EnvironmentKey {
    static var defaultValue: TimeInterval { 0.3 }
}


private struct ColorSchemeKey: EnvironmentKey {
    static var defaultValue: ColorScheme? { nil }
}
