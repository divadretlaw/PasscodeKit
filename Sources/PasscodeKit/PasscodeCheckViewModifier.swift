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
    @Environment(\.passcode.manager) private var passcodeManager
    @Environment(\.passcode.backgroundMaterial) private var backgroundMaterial
    
    @Binding var isPresented: Bool
    var allowBiometrics: Bool = false
    var onCompletion: (Bool) -> Void
    
    func body(content: Content) -> some View {
        if let passcode = passcodeManager.passcode {
            content
                .fullScreenCover(isPresented: $isPresented) {
                    NavigationView {
                        ZStack {
                            if let material = backgroundMaterial {
                                Color.clear
                                    .background(material, ignoresSafeAreaEdges: .all)
                            }
                            
                            PasscodeInputView(passcode: passcode, allowBiometrics: allowBiometrics, canCancel: true) { success in
                                onCompletion(success)
                                isPresented = false
                            }
                            .transparentBackground(hasBackground)
                        }
                    }
                    .transparentBackground(hasBackground)
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
    
    var hasBackground: Bool {
        backgroundMaterial != nil
    }
}
