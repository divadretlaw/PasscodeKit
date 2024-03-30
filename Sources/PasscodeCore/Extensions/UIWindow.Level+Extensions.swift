//
//  UIWindow.Level+Extensions.swift
//  PasscodeCore
//
//  Created by David Walter on 13.10.23.
//

import UIKit

extension UIWindow.Level {
    // Windows at this level appear on top of your app's main window and alerts.
    static var passcode: UIWindow.Level {
        /// `UIWindow.Level.alert` is `20_000` but in case this value is changed in the future
        /// we still want to be 1000 above alert, in order to fit potential other windows
        /// in between
        return UIWindow.Level(max(21_000, UIWindow.Level.alert.rawValue + 1000))
    }
}
