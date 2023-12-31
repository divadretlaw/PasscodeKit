//
//  BackgroundMaterialViewModifier.swift
//  PasscodeCore
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI

struct BackgroundMaterialViewModifier: ViewModifier {
    var material: Material?
    
    func body(content: Content) -> some View {
        if let material = material {
            content
                .opacity(0)
                .background(material, ignoresSafeAreaEdges: .all)
        } else {
            content
                .ignoresSafeArea(edges: .all)
        }
    }
}
