//
//  PasscodeSetupView.swift
//  PasscodeKit
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI
import PasscodeCore
@preconcurrency import LocalAuthentication

public struct PasscodeSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.passcode.setupForwardTransition) private var forwardTransition
    @Environment(\.passcode.setupBackwardTransition) private var backwardTransition
    
    enum Step: String, Identifiable {
        case initial
        case reEnter
        
        var id: String { rawValue }
    }
    
    var types: [PasscodeType]
    var allowBiometrics: Bool
    var onCompletion: (Passcode) -> Void
    
    @State private var type: PasscodeType
    @State private var code = ""
    @State private var currentStep: Step = .initial
    @State private var showBiometrics = false
    
    @State private var numberOfAttempts = 0
    
    @State private var task: Task<Void, Never>?
    
    public init(
        type: PasscodeType,
        allowBiometrics: Bool = true,
        onCompletion: @escaping (Passcode) -> Void
    ) {
        self.types = [type]
        self._type = State(initialValue: type)
        self.allowBiometrics = allowBiometrics
        self.onCompletion = onCompletion
    }
    
    public init(
        types: [PasscodeType],
        allowBiometrics: Bool = true,
        onCompletion: @escaping (Passcode) -> Void
    ) {
        self.types = types
        self._type = State(initialValue: types.first!)
        self.allowBiometrics = allowBiometrics
        self.onCompletion = onCompletion
    }
    
    public var body: some View {
        ZStack {
            switch currentStep {
            case .initial:
                inputView
                    .zIndex(0)
                    .transition(forwardTransition)
            case .reEnter:
                reEnterInputView
                    .zIndex(1)
                    .transition(backwardTransition)
            }
        }
        .confirmationDialog(localizedBiometrics ?? "", isPresented: $showBiometrics, titleVisibility: localizedBiometrics != nil ? .visible : .hidden) {
            Button {
                self.task = Task { @MainActor in
                    let context = LAContext()
                    do {
                        let reason = "passcode.biometrics.reason".localized()
                        let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
                        if success {
                            onCompletion(Passcode(code, type: type, allowBiometrics: true))
                        } else {
                            showBiometrics = true
                        }
                    } catch {
                        showBiometrics = true
                    }
                }
            } label: {
                Text(verbatim: "passcode.biometrics.setup.button".localized())
            }
            
            Button(role: .cancel) {
                onCompletion(Passcode(code, type: type, allowBiometrics: false))
            } label: {
                Text(verbatim: "passcode.biometrics.setup.cancel".localized())
            }
        } message: {
            if let localizedBiometrics {
                Text(verbatim: String(format: "passcode.biometrics.setup.message".localized(), localizedBiometrics))
            }
        }
        .animation(.default, value: currentStep)
        .navigationTitle("passcode.create.title".localized())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(role: .cancel) {
                    dismiss()
                } label: {
                    Text("cancel".localized())
                }
            }
        }
    }
    
    var inputView: some View {
        InternalPasscodeInputView(type: type, canCancel: false) { code in
            self.code = code
            return true
        } onCompletion: { _ in
            currentStep = .reEnter
        } hint: {
            if numberOfAttempts > 0 {
                Text("passcode.enter.failed.hint".localized())
            } else {
                Text("passcode.enter.hint".localized())
            }
        } options: {
            if types.count > 1 {
                Menu {
                    Picker(selection: $type) {
                        ForEach(types) { type in
                            Text(type.localized)
                                .tag(type)
                        }
                    } label: {
                        Text("passcode.type.options".localized())
                    }
                } label: {
                    Text("passcode.type.options".localized())
                }
            }
        }
        .animation(.default, value: type)
    }
    
    var reEnterInputView: some View {
        InternalPasscodeInputView(type: type, canCancel: false) { code in
            if self.code == code {
                return true
            } else {
                return fail()
            }
        } onCompletion: { success in
            if allowBiometrics, canUseBiometrics {
                showBiometrics = true
            } else {
                onCompletion(Passcode(code, type: type, allowBiometrics: false))
            }
        } hint: {
            Text("passcode.enter.again.hint".localized())
        }
        .onDisappear {
            task?.cancel()
        }
    }
    
    var canUseBiometrics: Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    var localizedBiometrics: String? {
        switch LAContext().biometryType {
        case .faceID:
            return "Face ID"
        case .touchID:
            return "Touch ID"
        default:
            return nil
        }
    }
    
    func fail() -> Bool {
        withAnimation(.default) {
            numberOfAttempts += 1
            currentStep = .initial
            
            withAnimation(.default.delay(1)) {
                reset()
            }
        }
        
        return false
    }
    
    func reset() {
        code = ""
        currentStep = .initial
    }
}

struct PasscodeSetupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PasscodeSetupView(type: .numeric(4)) { code in
                print(code)
            }
        }
    }
}
