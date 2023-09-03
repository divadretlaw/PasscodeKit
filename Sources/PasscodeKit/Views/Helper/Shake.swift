//
//  Shake.swift
//  PasscodeKit
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI

struct Shake: GeometryEffect {
    var amount: CGFloat
    var shakesPerUnit: CGFloat
    var animatableData: CGFloat
    
    init(amount: Int = 10, shakesPerUnit: Int = 3, animatableData: Int) {
        self.amount = CGFloat(amount)
        self.shakesPerUnit = CGFloat(shakesPerUnit)
        self.animatableData = CGFloat(animatableData)
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let value = amount * sin(animatableData * .pi * shakesPerUnit)
        return ProjectionTransform(CGAffineTransform(translationX: value, y: 0))
    }
}
