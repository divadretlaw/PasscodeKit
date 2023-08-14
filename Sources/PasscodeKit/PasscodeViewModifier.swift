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

struct PasscodeViewModifier<Hint>: ViewModifier where Hint: View {
    @Environment(\.passcodeKeychain) private var keychain
    @Environment(\.passcodeKey) private var passcodeKey
    @Environment(\.passcodeBackgroundMaterial) private var backgroundMaterial
    
    var title: Text?
    var mode: PasscodeMode
    var fallbackMode: PasscodeMode
    var hint: Hint
    
    func body(content: Content) -> some View {
        content
            .passcode(mode: computedMode, background: backgroundMaterial) { dismiss in
                if let passcode = passcode {
                    VStack {
                        if let title = title {
                            title
                                .font(.headline)
                                .padding(.top)
                        }
                        
                        PasscodeInputView(passcode: passcode, canCancel: false) { _ in
                            dismiss(animated: true)
                        } hint: {
                            hint
                        }
                    }
                }
            }
    }
    
    private var isSetup: Bool {
        keychain.get(passcodeKey) != nil
    }
    
    private var passcode: Passcode? {
        do {
            guard let data = keychain.getData(passcodeKey) else { return nil }
            return try JSONDecoder().decode(Passcode.self, from: data)
        } catch {
            return nil
        }
    }
    
    private var computedMode: PasscodeMode {
        guard isSetup else { return fallbackMode }
        return mode
    }
}

extension PasscodeViewModifier where Hint == EmptyView {
    init(title: Text? = nil, mode: PasscodeMode, fallbackMode: PasscodeMode) {
        self.title = title
        self.mode = mode
        self.fallbackMode = fallbackMode
        self.hint = EmptyView()
    }
}
