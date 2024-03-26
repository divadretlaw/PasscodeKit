//
//  ViewExtensions.swift
//  PasscodeKit
//
//  Created by David Walter on 13.08.23.
//

import SwiftUI

public extension View {
    func transparentBackground(_ isTransparent: Bool = true) -> some View {
        background(TransparentBackground(isTransparent: isTransparent))
    }
}

private struct TransparentBackground: UIViewRepresentable {
    var isTransparent: Bool
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = false
        view.alpha = 0
        
        DispatchQueue.main.async {
            guard let viewController = view.findViewController() else { return }
            viewController.view.backgroundColor = isTransparent ? .clear : .systemBackground
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let viewController = uiView.findViewController() else { return }
        viewController.view.backgroundColor = isTransparent ? .clear : .systemBackground
    }
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background {
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        }
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    func readSize(into size: Binding<CGSize>) -> some View {
        readSize {
            size.wrappedValue = $0
        }
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize {
        .zero
    }
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    }
}
