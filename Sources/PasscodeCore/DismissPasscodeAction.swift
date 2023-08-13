//
//  PasscodeDismissAction.swift
//  PasscodeCore
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI

public struct DismissPasscodeAction {
    var action: (_ animated: Bool) -> Void
    
    public func callAsFunction(animated: Bool) {
        action(animated)
    }
}

public extension EnvironmentValues {
    var dismissPasscode: DismissPasscodeAction {
        get { self[DismissPasscodeActionKey.self] }
        set { self[DismissPasscodeActionKey.self] = newValue }
    }
}

public extension View {
    func onDismissPasscode(perform: @escaping (_ animated: Bool) -> Void) -> some View {
        environment(\.dismissPasscode, DismissPasscodeAction(action: perform))
    }
    
    func onDismissPasscode(action: DismissPasscodeAction) -> some View {
        environment(\.dismissPasscode, action)
    }
}

struct DismissPasscodeActionKey: EnvironmentKey {
    static var defaultValue: DismissPasscodeAction {
        DismissPasscodeAction { _ in
        }
    }
}
