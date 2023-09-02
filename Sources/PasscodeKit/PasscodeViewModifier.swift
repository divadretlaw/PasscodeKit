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
    @Environment(\.passcode.manager) private var passcodeManager
    @Environment(\.passcode.backgroundMaterial) private var backgroundMaterial
    
    var title: Text?
    var mode: PasscodeMode
    var fallbackMode: PasscodeMode
    var hint: Hint
    
    func body(content: Content) -> some View {
        content
            .passcode(mode: computedMode, background: backgroundMaterial) { dismiss in
                if let passcode = passcodeManager.passcode {
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
    
    private var computedMode: PasscodeMode {
        guard passcodeManager.isSetup else { return fallbackMode }
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
