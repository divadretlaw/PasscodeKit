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
    @Environment(\.passcodeKeychain) private var keychain
    @Environment(\.passcodeKey) private var passcodeKey
    @Environment(\.passcodeKeychainAccessOption) private var keychainAccessOption
    
    @Binding var isPresented: Bool
    var type: PasscodeType
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                NavigationView {
                    PasscodeSetupView(type: type) { code in
                        defer { self.isPresented = false }
                        
                        do {
                            let data = try JSONEncoder().encode(code)
                            keychain.set(data, forKey: passcodeKey, withAccess: keychainAccessOption)
                        } catch {
                            print(error.localizedDescription)
                            keychain.delete(passcodeKey)
                        }
                    }
                }
            }
    }
}
