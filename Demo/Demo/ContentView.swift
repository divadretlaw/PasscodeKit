//
//  ContentView.swift
//  Demo
//
//  Created by David Walter on 08.08.23.
//

import SwiftUI
import PasscodeKit
import KeychainSwift

struct ContentView: View {
    @Environment(\.passcode.manager) private var passcodeManager
    
    @State private var setupPasscode = false
    @State private var changePasscode = false
    @State private var checkPasscodeOrBiometrics = false
    @State private var checkPasscode = false
    
    @State private var hasPasscode = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        setupPasscode = true
                    } label: {
                        Text("Setup Passcode")
                    }
                } header: {
                    Text("Setup")
                }
                .disabled(hasPasscode)
                
                Section {
                    Button {
                        changePasscode = true
                    } label: {
                        Text("Change Passcode")
                    }
                } header: {
                    Text("Change")
                }
                .disabled(!hasPasscode)
                
                Button {
                    checkPasscodeOrBiometrics = true
                } label: {
                    Text("Check Passcode (Biometrics Enabled)")
                }
                .disabled(!hasPasscode)
                
                Button {
                    checkPasscode = true
                } label: {
                    Text("Check Passcode (Biometrics Disabled)")
                }
                .disabled(!hasPasscode)
                
                Button(role: .destructive) {
                    passcodeManager.delete()
                    evaluatePasscode()
                } label: {
                    Text("Delete Passcode")
                }
                .disabled(!hasPasscode)
                
                Section {
                    NavigationLink {
                        VStack(spacing: 0) {
                            RainbowView()
                        }
                        .ignoresSafeArea()
                    } label: {
                        Text("Rainbow")
                    }

                    Group {
                        Color.red
                        Color.orange
                        Color.yellow
                        Color.green
                        Color.blue
                        Color.purple
                    }
                    .listRowInsets(EdgeInsets())
                } header: {
                    Text("Colors")
                }
            }
            .navigationTitle("Demo")
            .onAppear {
                evaluatePasscode()
            }
            .setupPasscode(isPresented: $setupPasscode, types: passcodes) { _ in
                evaluatePasscode()
            }
            .changePasscode(isPresented: $changePasscode, types: passcodes) { _ in
                evaluatePasscode()
            }
            .checkPasscode(isPresented: $checkPasscode) { _ in
                evaluatePasscode()
            }
            .checkPasscode(isPresented: $checkPasscodeOrBiometrics, allowBiometrics: true) { _ in
                evaluatePasscode()
            }
        }
    }
    
    var passcodes: [PasscodeType] {
        [.numeric(4), .numeric(6), .alphanumeric]
    }
    
    func evaluatePasscode() {
        hasPasscode = passcodeManager.isSetup
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
