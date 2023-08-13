//
//  StringExtensions.swift
//  PasscodeUI
//
//  Created by David Walter on 13.08.23.
//

import Foundation

extension String {
    func localized(comment: String = "") -> String {
        let bundle = Bundle.main.path(forResource: "Passcode", ofType: "strings") != nil ? Bundle.main : Bundle.module
        return NSLocalizedString(self, tableName: "Passcode", bundle: bundle, comment: comment)
    }
}
