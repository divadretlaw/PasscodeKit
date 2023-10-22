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
                    PasscodeChangeView(types: types) { code in
                        defer { self.isPresented = false }
                        
                        let result = passcodeManager.setPasscode(code)
                        onCompletion?(result)
                    }
                }
            }
    }
}
