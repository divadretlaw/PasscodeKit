//
//  PasscodeScrollView.swift
//  PasscodeKit
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI
import SwiftUIIntrospect

/// Wrapper for `ScrollView`
struct PasscodeScrollView<Content>: View where Content: View {
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { proxy in
            if #unavailable(iOS 16.4) {
                scrollView(proxy: proxy)
                    .introspect(.scrollView, on: .iOS(.v15, .v16), scope: .ancestor) { scrollView in
                        scrollView.alwaysBounceVertical = false
                        scrollView.alwaysBounceHorizontal = false
                    }
            } else {
                scrollView(proxy: proxy)
                    .scrollBounceBehavior(.basedOnSize)
            }
        }
    }
    
    func scrollView(proxy: GeometryProxy) -> some View {
        ScrollView(.vertical) {
            VStack {
                content
            }
            .frame(maxWidth: .infinity, minHeight: proxy.size.height)
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
