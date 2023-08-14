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
    func passcode(mode: PasscodeMode = .default, fallbackMode: PasscodeMode = .autohide) -> some View {
        modifier(PasscodeViewModifier(mode: mode, fallbackMode: fallbackMode))
    }
    
    /// Manually check the passcode
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the passcode view.
    ///   - isTransparent: Wheter to present the passcode view as a transparent blurred overlay.
    ///   - onCompletion: The closure to execute when the passcode was checked.
    func checkPasscode(isPresented: Binding<Bool>, isTransparent: Bool = true, onCompletion: @escaping (Bool) -> Void) -> some View {
        modifier(PasscodeCheckViewModifier(isPresented: isPresented, isTransparent: isTransparent, onCompletion: onCompletion))
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
