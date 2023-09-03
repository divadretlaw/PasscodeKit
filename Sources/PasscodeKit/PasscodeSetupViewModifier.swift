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
    var type: PasscodeType
    var onCompletion: ((Bool) -> Void)?
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                NavigationView {
                    PasscodeSetupView(type: type) { code in
                        defer { self.isPresented = false }
                        
                        let result = passcodeManager.setPasscode(code)
                        onCompletion?(result)
                    }
                }
            }
    }
}
