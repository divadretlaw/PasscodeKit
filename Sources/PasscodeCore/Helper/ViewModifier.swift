//
//  ViewModifier.swift
//  PasscodeCore
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI

extension View {
    @inlinable func modifier<T>(_ modifier: () -> T) -> ModifiedContent<Self, T> {
        self.modifier(modifier())
    }
}
