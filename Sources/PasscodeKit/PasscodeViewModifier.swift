//
//  PasscodeViewModifier.swift
//  PasscodeKit
//
//  Created by David Walter on 13.08.23.
//

import SwiftUI
import PasscodeCore
import PasscodeModel
import PasscodeUI

struct PasscodeViewModifier: ViewModifier {
    @Environment(\.passcodeKeychain) private var keychain
    @Environment(\.passcodeKey) private var passcodeKey
    
    func body(content: Content) -> some View {
        content
            .passcode(mode: mode) { dismiss in
                if let passcode = passcode {
                    PasscodeInputView(passcode: passcode, canCancel: false) { _ in
                        dismiss(animated: true)
                    }
                }
            }
    }
    
    var isSetup: Bool {
        keychain.get(passcodeKey) != nil
    }
    
    var passcode: Passcode? {
        do {
            guard let data = keychain.getData(passcodeKey) else { return nil }
            return try JSONDecoder().decode(Passcode.self, from: data)
        } catch {
            return nil
        }
    }
    
    var mode: PasscodeMode {
        guard isSetup else { return .autohide }
        return .hideInAppSwitcher
    }
}
