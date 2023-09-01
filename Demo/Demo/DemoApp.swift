//
//  DemoApp.swift
//  Demo
//
//  Created by David Walter on 08.08.23.
//

import SwiftUI
import PasscodeKit
import SimulatorStatusMagic

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .passcode("Enter Passcode")
                .onAppear {
//                    SDStatusBarManager.sharedInstance().enableOverrides()
                }
        }
    }
}
