//
//  PasscodeSetupConfiguration.swift
//  PasscodeKit
//
//  Created by David Walter on 22.10.23.
//

import SwiftUI

public extension PasscodeEnvironmentValues {
    /// The transition when the setup/change wizard moves forward
    var setupForwardTransition: AnyTransition {
        get { self[PasscodeSetupForwardTransitionKey.self] }
        set { self[PasscodeSetupForwardTransitionKey.self] = newValue }
    }
    
    /// The transition when the setup/change wizard moves backward
    var setupBackwardTransition: AnyTransition {
        get { self[PasscodeSetupBackwardTransitionKey.self] }
        set { self[PasscodeSetupBackwardTransitionKey.self] = newValue }
    }
}

private struct PasscodeSetupForwardTransitionKey: EnvironmentKey {
    static var defaultValue: AnyTransition {
        .move(edge: .leading)
    }
}

private struct PasscodeSetupBackwardTransitionKey: EnvironmentKey {
    static var defaultValue: AnyTransition {
        .move(edge: .trailing)
    }
}
