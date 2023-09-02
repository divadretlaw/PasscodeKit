//
//  Environment.swift
//  PasscodeKit
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI
import KeychainSwift
import PasscodeCore

public extension PasscodeEnvironmentValues {
    /// The ``PasscodeManager`` to manage the passcode.
    var manager: PasscodeManager {
        get { self[PasscodeManagerKey.self] }
        set { self[PasscodeManagerKey.self] = newValue }
    }
    
    /// The background material to use when presenting the passcode view.
    var backgroundMaterial: Material? {
        get { self[PasscodeBackgroundMaterialKey.self] }
        set { self[PasscodeBackgroundMaterialKey.self] = newValue }
    }
}

struct PasscodeManagerKey: EnvironmentKey {
    static var defaultValue: PasscodeManager {
        PasscodeManager()
    }
}

struct PasscodeBackgroundMaterialKey: EnvironmentKey {
    static var defaultValue: Material? {
        .regular
    }
}
