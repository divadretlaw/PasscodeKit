//
//  DemoApp.swift
//  Demo
//
//  Created by David Walter on 08.08.23.
//

import SwiftUI
import PasscodeKit

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .passcode()
        }
    }
}
