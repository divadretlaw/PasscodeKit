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
    func passcode() -> some View {
        modifier(PasscodeViewModifier())
    }
    
    func checkPasscode(isPresented: Binding<Bool>, onCompletion: @escaping (Bool) -> Void) -> some View {
        modifier(PasscodeCheckViewModifier(isPresented: isPresented, onCompletion: onCompletion))
    }
    
    func setupPasscode(isPresented: Binding<Bool>, type: PasscodeType = .numeric(4)) -> some View {
        modifier(PasscodeSetupViewModifier(isPresented: isPresented, type: type))
    }
}
