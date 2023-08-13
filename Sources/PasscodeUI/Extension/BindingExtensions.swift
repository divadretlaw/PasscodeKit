//
//  BindingExtensions.swift
//  PasscodeUI
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            Task { @MainActor in
                self.wrappedValue = String(self.wrappedValue.prefix(limit))
            }
        }
        
        return self
    }
}
