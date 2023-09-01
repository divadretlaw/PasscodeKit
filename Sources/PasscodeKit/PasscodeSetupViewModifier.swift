//
//  PasscodeSetupViewModifier.swift
//  PasscodeKit
//
//  Created by David Walter on 13.08.23.
//

import SwiftUI
import PasscodeCore
import PasscodeModel
import PasscodeUI

struct PasscodeSetupViewModifier: ViewModifier {
    @Environment(\.passcodeManager) private var passcodeManager
    
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
