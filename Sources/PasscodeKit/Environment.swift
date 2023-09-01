//
//  Environment.swift
//  PasscodeKit
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI
import KeychainSwift

public extension EnvironmentValues {
    /// The ``PasscodeManager`` to manage the passcode.
    var passcodeManager: PasscodeManager {
        get { self[PasscodeManagerKey.self] }
        set { self[PasscodeManagerKey.self] = newValue }
    }
    
    /// The background material to use when presenting the passcode view.
    var passcodeBackgroundMaterial: Material? {
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
