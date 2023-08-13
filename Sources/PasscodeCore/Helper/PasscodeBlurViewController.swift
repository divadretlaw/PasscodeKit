//
//  PasscodeBlurViewController.swift
//  PasscodeCore
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI

final class PasscodeBlurViewController<Content>: UIHostingController<Content> where Content: View {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
}
