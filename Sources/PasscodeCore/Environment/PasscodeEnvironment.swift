//
//  PasscodeEnvironment.swift
//  PasscodeCore
//
//  Created by David Walter on 02.09.23.
//

import SwiftUI

/// A collection of passcode environment values propagated through a view hierarchy.
public struct PasscodeEnvironmentValues: CustomStringConvertible {
    private var values: EnvironmentValues
    
    /// Creates a passcode environment values instance.
    ///
    /// You don't typically create an instance of ``EnvironmentValues``
    /// directly. Doing so would provide access only to default values that
    /// don't update based on system settings or device characteristics.
    /// Instead, you rely on an environment values' instance
    /// that SwiftUI manages for you when you use the ``Environment``
    /// property wrapper and the ``View/environment(_:_:)`` view modifier.
    public init() {
        self.values = EnvironmentValues()
    }
    
    /// Accesses the environment value associated with a custom key.
    ///
    /// Create custom environment values by defining a key
    /// that conforms to the ``EnvironmentKey`` protocol, and then using that
    /// key with the subscript operator of the ``EnvironmentValues`` structure
    /// to get and set a value for that key:
    ///
    ///     private struct MyEnvironmentKey: EnvironmentKey {
    ///         static let defaultValue: String = "Default value"
    ///     }
    ///
    ///     extension PasscodeEnvironmentValues {
    ///         var myCustomValue: String {
    ///             get { self[MyEnvironmentKey.self] }
    ///             set { self[MyEnvironmentKey.self] = newValue }
    ///         }
    ///     }
    ///
    /// You use custom environment values the same way you use system-provided
    /// values, setting a value with the ``View/environment(_:_:)`` view
    /// modifier, and reading values with the ``Environment`` property wrapper.
    /// You can also provide a dedicated view modifier as a convenience for
    /// setting the value:
    ///
    ///     extension View {
    ///         func myCustomValue(_ myCustomValue: String) -> some View {
    ///             environment(\.passcode.myCustomValue, myCustomValue)
    ///         }
    ///     }
    ///
    public subscript<K>(key: K.Type) -> K.Value where K: EnvironmentKey {
        get { values[key] }
        set { values[key] = newValue }
    }
    
    /// A string that represents the contents of the environment values instance.
    public var description: String {
        values.description
    }
}

private struct PasscodeEnvironmentKey: EnvironmentKey {
    static var defaultValue: PasscodeEnvironmentValues {
        PasscodeEnvironmentValues()
    }
}

extension EnvironmentValues {
    /// The passcode environment values. A subset of `SwiftUI.EnvironmentValues`
    /// that only contains values related to passcode.
    public var passcode: PasscodeEnvironmentValues {
        get { self[PasscodeEnvironmentKey.self] }
        set { self[PasscodeEnvironmentKey.self] = newValue }
    }
}
