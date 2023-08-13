//
//  PasscodeRootView.swift
//  PasscodeCore
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI

struct PasscodeRootView<P, B>: View where P: View, B: View {
    @Environment(\.dismissPasscode) private var dismiss
    
    @Binding var isShowingPasscode: Bool
    
    @ViewBuilder var view: (_ dismiss: DismissPasscodeAction) -> P
    @ViewBuilder var background: () -> B
    
    var body: some View {
        ZStack {
            background()
            
            if isShowingPasscode {
                view(dismiss)
            }
        }
    }
}
