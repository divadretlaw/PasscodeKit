//
//  UIViewExtensions.swift
//  PasscodeKit
//
//  Created by David Walter on 14.08.23.
//

import UIKit

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = next as? UIViewController {
            return nextResponder
        } else if let nextResponder = next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
