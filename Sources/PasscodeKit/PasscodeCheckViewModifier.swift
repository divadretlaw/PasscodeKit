//
//  PasscodeCheckViewModifier.swift
//  PasscodeKit
//
//  Created by David Walter on 13.08.23.
//

import SwiftUI
import PasscodeCore
import PasscodeModel
import PasscodeUI

struct PasscodeCheckViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    var onCompletion: (Bool) -> Void
    
    @Environment(\.passcodeKeychain) private var keychain
    @Environment(\.passcodeKey) private var passcodeKey
    
    func body(content: Content) -> some View {
        if let passcode = passcode {
            content
                .fullScreenCover(isPresented: $isPresented) {
                    NavigationView {
                        PasscodeInputView(passcode: passcode, canCancel: true) { success in
                            onCompletion(success)
                            isPresented = false
                        }
                    }
                }
        } else {
            content
                .onAppear {
                    defer { self.isPresented = false }
                    guard isPresented else { return }
                    onCompletion(true)
                }
                .onChange(of: isPresented) { isPresented in
                    defer { self.isPresented = false }
                    guard isPresented else { return }
                    onCompletion(true)
                }
        }
    }
    
    var passcode: Passcode? {
        do {
            guard let data = keychain.getData(passcodeKey) else { return nil }
            return try JSONDecoder().decode(Passcode.self, from: data)
        } catch {
            return nil
        }
    }
}
