//
//  PasscodeScrollView.swift
//  PasscodeUI
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI

struct PasscodeScrollView<Content>: View where Content: View {
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { proxy in
            if #unavailable(iOS 16.4) {
                ScrollView {
                    VStack {
                        content
                    }
                    .frame(maxWidth: .infinity, minHeight: proxy.size.height)
                }
            } else {
                ScrollView {
                    VStack {
                        content
                    }
                    .frame(maxWidth: .infinity, minHeight: proxy.size.height)
                }
                .scrollBounceBehavior(.basedOnSize)
            }
        }
    }
}

struct PasscodeScrollView_Previews: PreviewProvider {
    static var previews: some View {
        PasscodeScrollView {
            Text("Test")
        }
    }
}
