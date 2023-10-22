//
//  PasscodeCheckViewModifier.swift
//  PasscodeKit
//
//  Created by David Walter on 13.08.23.
//

import SwiftUI
import PasscodeCore

struct PasscodeCheckViewModifier: ViewModifier {
    @Environment(\.passcode.manager) private var passcodeManager
    @Environment(\.passcode.backgroundMaterial) private var backgroundMaterial
    
    @Binding var isPresented: Bool
    var allowBiometrics: Bool
    var onCompletion: (Bool) -> Void
    @State private var item: Passcode?
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $item) { passcode in
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
            .onAppear {
                item = isPresented ? passcodeManager.passcode : nil
            }
            .onChange(of: isPresented) { isPresented in
                item = isPresented ? passcodeManager.passcode : nil
            }
    }
    
    var hasBackground: Bool {
        backgroundMaterial != nil
    }
}
