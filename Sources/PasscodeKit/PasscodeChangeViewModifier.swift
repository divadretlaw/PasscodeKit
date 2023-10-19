//
//  PasscodeChangeViewModifier.swift
//  PasscodeKit
//
//  Created by David Walter on 19.10.23.
//

import SwiftUI
import PasscodeCore

struct PasscodeChangeViewModifier: ViewModifier {
    @Environment(\.passcode.manager) private var passcodeManager
    
    @Binding var isPresented: Bool
    var type: PasscodeType
    var onCompletion: ((Bool) -> Void)?
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                NavigationView {
                    PasscodeChangeView(type: type) { code in
                        defer { self.isPresented = false }
                        
                        let result = passcodeManager.setPasscode(code)
                        onCompletion?(result)
                    }
                }
            }
    }
}
