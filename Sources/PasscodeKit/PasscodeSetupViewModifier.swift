//
//  PasscodeSetupViewModifier.swift
//  PasscodeKit
//
//  Created by David Walter on 13.08.23.
//

import SwiftUI
import PasscodeCore

struct PasscodeSetupViewModifier: ViewModifier {
    @Environment(\.passcode.manager) private var passcodeManager
    
    @Binding var isPresented: Bool
    var types: [PasscodeType]
    var onCompletion: ((Bool) -> Void)?
    
    init(isPresented: Binding<Bool>, type: PasscodeType, onCompletion: ((Bool) -> Void)? = nil) {
        self._isPresented = isPresented
        self.types = [type]
        self.onCompletion = onCompletion
    }
    
    init(isPresented: Binding<Bool>, types: [PasscodeType], onCompletion: ((Bool) -> Void)? = nil) {
        self._isPresented = isPresented
        self.types = types
        self.onCompletion = onCompletion
    }
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                NavigationView {
                    PasscodeSetupView(types: types) { code in
                        defer { self.isPresented = false }
                        
                        let result = passcodeManager.setPasscode(code)
                        onCompletion?(result)
                    }
                }
            }
    }
}
