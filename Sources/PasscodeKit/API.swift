//
//  Passcode.swift
//  PasscodeKit
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI
import PasscodeCore
import PasscodeModel
import PasscodeUI
import KeychainSwift

public extension View {
    /// Add passcode protection to your app.
    ///
    /// - Parameters:
    ///   - mode: The ``PasscodeMode`` to use when the passcode is setup.
    ///   - fallbackMode: The fallback ``PasscodeMode`` to use when the passcode is not yet setup by the user.
    /// - Returns: The view with passcode protection enabled
    func passcode(
        _ text: Text? = nil,
        mode: PasscodeMode = .default,
        fallbackMode: PasscodeMode = .autohide
    ) -> some View {
        modifier(PasscodeViewModifier(title: text, mode: mode, fallbackMode: fallbackMode))
    }
    
    /// Add passcode protection to your app.
    ///
    /// - Parameters:
    ///   - mode: The ``PasscodeMode`` to use when the passcode is setup.
    ///   - fallbackMode: The fallback ``PasscodeMode`` to use when the passcode is not yet setup by the user.
    /// - Returns: The view with passcode protection enabled
    func passcode(
        _ title: LocalizedStringKey,
        mode: PasscodeMode = .default,
        fallbackMode: PasscodeMode = .autohide
    ) -> some View {
        modifier(PasscodeViewModifier(title: Text(title), mode: mode, fallbackMode: fallbackMode))
    }
    
    /// Add passcode protection to your app.
    ///
    /// - Parameters:
    ///   - mode: The ``PasscodeMode`` to use when the passcode is setup.
    ///   - fallbackMode: The fallback ``PasscodeMode`` to use when the passcode is not yet setup by the user.
    /// - Returns: The view with passcode protection enabled
    func passcode<S>(
        _ title: S, mode: PasscodeMode = .default,
        fallbackMode: PasscodeMode = .autohide
    ) -> some View where S: StringProtocol {
        modifier(PasscodeViewModifier(title: Text(title), mode: mode, fallbackMode: fallbackMode))
    }
    
    /// Add passcode protection to your app.
    ///
    /// - Parameters:
    ///   - mode: The ``PasscodeMode`` to use when the passcode is setup.
    ///   - fallbackMode: The fallback ``PasscodeMode`` to use when the passcode is not yet setup by the user.
    /// - Returns: The view with passcode protection enabled
    func passcode<Hint>(
        _ text: Text? = nil,
        mode: PasscodeMode = .default,
        fallbackMode: PasscodeMode = .autohide,
        @ViewBuilder hint: () -> Hint
    ) -> some View where Hint: View {
        modifier(PasscodeViewModifier(title: text, mode: mode, fallbackMode: fallbackMode, hint: hint()))
    }
    
    /// Add passcode protection to your app.
    ///
    /// - Parameters:
    ///   - mode: The ``PasscodeMode`` to use when the passcode is setup.
    ///   - fallbackMode: The fallback ``PasscodeMode`` to use when the passcode is not yet setup by the user.
    /// - Returns: The view with passcode protection enabled
    func passcode<Hint>(
        _ title: LocalizedStringKey,
        mode: PasscodeMode = .default,
        fallbackMode: PasscodeMode = .autohide,
        @ViewBuilder hint: () -> Hint
    ) -> some View where Hint: View {
        modifier(PasscodeViewModifier(title: Text(title), mode: mode, fallbackMode: fallbackMode, hint: hint()))
    }
    
    /// Add passcode protection to your app.
    ///
    /// - Parameters:
    ///   - mode: The ``PasscodeMode`` to use when the passcode is setup.
    ///   - fallbackMode: The fallback ``PasscodeMode`` to use when the passcode is not yet setup by the user.
    /// - Returns: The view with passcode protection enabled
    func passcode<S, Hint>(
        _ title: S, mode: PasscodeMode = .default,
        fallbackMode: PasscodeMode = .autohide,
        @ViewBuilder hint: () -> Hint
    ) -> some View where S: StringProtocol, Hint: View {
        modifier(PasscodeViewModifier(title: Text(title), mode: mode, fallbackMode: fallbackMode, hint: hint()))
    }
    
    /// Manually check the passcode
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the passcode view.
    ///   - allowBiometrics: Allow to identify using biometrics.
    ///   - onCompletion: The closure to execute when the passcode was checked.
    func checkPasscode(
        isPresented: Binding<Bool>,
        allowBiometrics: Bool = false,
        onCompletion: @escaping (Bool) -> Void
    ) -> some View {
        modifier(PasscodeCheckViewModifier(isPresented: isPresented, allowBiometrics: allowBiometrics, onCompletion: onCompletion))
    }
    
    /// Setup a passcode
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the passcode view.
    ///   - type: The ``PasscodeType`` to setup.
    func setupPasscode(
        isPresented: Binding<Bool>,
        type: PasscodeType = .numeric(4),
        onCompletion: ((Bool) -> Void)? = nil
    ) -> some View {
        modifier(PasscodeSetupViewModifier(isPresented: isPresented, type: type, onCompletion: onCompletion))
    }
}
