//
//  ContentView.swift
//  Demo
//
//  Created by David Walter on 08.08.23.
//

import SwiftUI
import PasscodeKit
import KeychainSwift
import PasscodeModel

struct ContentView: View {
    @Environment(\.passcodeManager) private var passcodeManager
    
    @State private var setupPasscode = false
    @State private var passcodeType: PasscodeType = .numeric(4)
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
                    
                    Picker(selection: $passcodeType) {
                        Text("Numeric (4 digits)")
                            .tag(PasscodeType.numeric(4))
                        Text("Numeric (6 digits)")
                            .tag(PasscodeType.numeric(6))
                        Text("Numeric (custom)")
                            .tag(PasscodeType.customNumeric)
                        Text("Alphanumeric (custom)")
                            .tag(PasscodeType.alphanumeric)
                    } label: {
                        Text("Type")
                    }
                } header: {
                    Text("Setup")
                }
                .disabled(hasPasscode)
                
                Button {
                    checkPasscode = true
                } label: {
                    Text("Check Passcode")
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
            .setupPasscode(isPresented: $setupPasscode, type: passcodeType) { _ in
                evaluatePasscode()
            }
            .checkPasscode(isPresented: $checkPasscode) { _ in
                evaluatePasscode()
            }
        }
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
