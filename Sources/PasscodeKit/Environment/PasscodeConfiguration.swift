//
//  PasscodeConfiguration.swift
//  PasscodeKit
//
//  Created by David Walter on 02.09.23.
//

import SwiftUI
import PasscodeCore

public extension PasscodeEnvironmentValues {
    var tintColor: Color? {
        get { self[PasscodeTintColorKey.self] }
        set { self[PasscodeTintColorKey.self] = newValue }
    }
    
    /// The background material to use when presenting the passcode view.
    var backgroundMaterial: Material? {
        get { self[PasscodeBackgroundMaterialKey.self] }
        set { self[PasscodeBackgroundMaterialKey.self] = newValue }
    }
}

private struct PasscodeTintColorKey: EnvironmentKey {
    static var defaultValue: Color? {
        .accentColor
    }
}

private struct PasscodeBackgroundMaterialKey: EnvironmentKey {
    static var defaultValue: Material? {
        .regular
    }
}
