//
//  DismissPasscodeAction.swift
//  PasscodeCore
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI

/// An action that dismisses the current passcode presentation.
///
/// Use the ``EnvironmentValues/dismiss`` environment value to get the instance
/// of this structure for a given ``Environment``. Then call the instance
/// to perform the dismissal. You call the instance directly because
/// it defines a ``DismissPasscodeAction/callAsFunction()``
/// method that Swift calls when you call the instance.
public struct DismissPasscodeAction {
    var action: (_ animated: Bool) -> Void
    
    /// Dismisses the passcode if it is currently presented.
    ///
    /// Don't call this method directly. SwiftUI calls it for you when you
    /// call the ``DismissPasscodeAction`` structure that you get from the
    /// ``Environment``:
    ///
    /// ```swift
    /// private struct PasscodeView: View {
    ///     @Environment(\.dismissPasscode) private var dismissPasscode
    ///
    ///     var body: some View {
    ///         Button("Dismiss Passcode") {
    ///             dismissPasscode(animated: true) // Implicitly calls dismissPasscode.callAsFunction(animated:)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// For information about how Swift uses the `callAsFunction()` method to
    /// simplify call site syntax, see
    /// [Methods with Special Names](https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#ID622)
    /// in *The Swift Programming Language*.
    public func callAsFunction(animated: Bool) {
        action(animated)
    }
}

public extension PasscodeEnvironmentValues {
    /// An action that dismisses the current passcode presentation.
    var dismiss: DismissPasscodeAction {
        get { self[DismissPasscodeActionKey.self] }
        set { self[DismissPasscodeActionKey.self] = newValue }
    }
}

extension View {
    /// Performs an action when the passcode shoudl dismiss.
    ///
    /// - Parameters:
    ///     - action: A closure to run when passcode should dismiss. The closure
    ///     takes a `animated` parameter that indicates whether the dismiss should be animated
    ///     or not.
    ///
    /// - Returns: A view that runs an action when the passcode should dismiss.
    func onDismissPasscode(perform action: @escaping (_ animated: Bool) -> Void) -> some View {
        environment(\.passcode.dismiss, DismissPasscodeAction(action: action))
    }
    
    /// Performs an action when the passcode shoudl dismiss.
    ///
    /// - Parameters:
    ///     - action: The ``DismissPasscodeAction`` to run when the passcode should dismiss.
    ///
    /// - Returns: A view that runs an action when the passcode should dismiss.
    func onDismissPasscode(action: DismissPasscodeAction) -> some View {
        environment(\.passcode.dismiss, action)
    }
}

struct DismissPasscodeActionKey: EnvironmentKey {
    static var defaultValue: DismissPasscodeAction {
        DismissPasscodeAction { _ in
        }
    }
}
