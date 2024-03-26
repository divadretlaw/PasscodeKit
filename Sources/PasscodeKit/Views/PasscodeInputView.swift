//
//  PasscodeInputView.swift
//  PasscodeKit
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI
import PasscodeCore
@preconcurrency import LocalAuthentication

public struct PasscodeInputView<Hint>: View where Hint: View {
    var type: PasscodeType
    var allowBiometrics: Bool = true
    var canCancel: Bool
    var check: (String) -> Bool
    var onCompletion: (Bool) -> Void
    @ViewBuilder var hint: () -> Hint
    
    public init(
        passcode: Passcode,
        allowBiometrics: Bool = true,
        canCancel: Bool = false,
        onCompletion: @escaping (Bool) -> Void,
        @ViewBuilder hint: @escaping () -> Hint
    ) {
        self.type = passcode.type
        self.allowBiometrics = passcode.isBiometricsEnabled && allowBiometrics
        self.canCancel = canCancel
        self.check = { passcode.code == $0 }
        self.onCompletion = onCompletion
        self.hint = hint
    }
    
    public init(
        type: PasscodeType,
        allowBiometrics: Bool = true,
        canCancel: Bool = false,
        check: @escaping (String) -> Bool,
        onCompletion: @escaping (Bool) -> Void,
        @ViewBuilder hint: @escaping () -> Hint
    ) {
        self.type = type
        self.allowBiometrics = allowBiometrics
        self.canCancel = canCancel
        self.check = check
        self.onCompletion = onCompletion
        self.hint = hint
    }
    
    public var body: some View {
        InternalPasscodeInputView(
            type: type,
            canCancel: canCancel,
            check: check,
            onCompletion: onCompletion,
            hint: hint
        )
        .biometryAction(allowBiometrics) {
            await checkBiometry()
        }
        .task {
            await checkBiometry()
        }
        .navigationTitle("passcode.enter.title".localized())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                if canCancel {
                    Button(role: .cancel) {
                        onCompletion(false)
                    } label: {
                        Text("cancel".localized())
                    }
                }
            }
        }
    }
    
    @MainActor
    private func checkBiometry() async {
        guard allowBiometrics else { return }
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else { return }
        let reason = "passcode.biometrics.reason".localized()
        
        do {
            let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
            guard success else { return }
            onCompletion(true)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension PasscodeInputView where Hint == EmptyView {
    public init(
        type: PasscodeType,
        allowBiometrics: Bool = true,
        canCancel: Bool = false,
        check: @escaping (String) -> Bool,
        onCompletion: @escaping (Bool) -> Void
    ) {
        self.type = type
        self.allowBiometrics = allowBiometrics
        self.canCancel = canCancel
        self.check = check
        self.onCompletion = onCompletion
        self.hint = { EmptyView() }
    }
    
    public init(
        passcode: Passcode,
        allowBiometrics: Bool = true,
        canCancel: Bool = false,
        onCompletion: @escaping (Bool) -> Void
    ) {
        self.type = passcode.type
        self.allowBiometrics = passcode.isBiometricsEnabled && allowBiometrics
        self.canCancel = canCancel
        self.check = { passcode.code == $0 }
        self.onCompletion = onCompletion
        self.hint = { EmptyView() }
    }
}

struct InternalPasscodeInputView<Hint, Options>: View where Hint: View, Options: View {
    @Environment(\.passcode.tintColor) private var tintColor
    
    var type: PasscodeType
    var canCancel: Bool
    var check: (String) -> Bool
    var onCompletion: (Bool) -> Void
    var biometryAction: (() async -> Void)?
    
   var hint: Hint
   var options: Options
    
    @State private var input = ""
    @State private var passcode = ""
    @State private var attempts = 0
    @State private var isDisabled = false
    
    @FocusState private var alphaNumericInput
    
    init(
        type: PasscodeType,
        canCancel: Bool,
        check: @escaping (String) -> Bool,
        onCompletion: @escaping (Bool) -> Void,
        biometryAction: (() async -> Void)? = nil,
        @ViewBuilder hint: () -> Hint,
        @ViewBuilder options: () -> Options
    ) {
        self.type = type
        self.canCancel = canCancel
        self.check = check
        self.onCompletion = onCompletion
        self.biometryAction = biometryAction
        self.hint = hint()
        self.options = options()
    }
    
    public var body: some View {
        PasscodeScrollView {
            Spacer()
            
            VStack(spacing: 20) {
                hint
                
                CodeView(text: input, type: type)
                    .padding(.horizontal, 40)
                    .modifier(Shake(animatableData: attempts))
                    .background {
                        if type.isAlphaNumeric {
                            SecureField("", text: $input)
                                .focused($alphaNumericInput)
                                .onAppear {
                                    alphaNumericInput = true
                                }
                                .allowsHitTesting(false)
                                .accessibilityHidden(true)
                                .opacity(0)
                        }
                    }
                
                options
            }
            
            if type.isNumeric {
                Spacer()
                
                KeypadView(text: $input.max(type.maxInputLength), biometryAction: biometryAction)
                    .foregroundStyle(.primary)
                    .disabled(isDisabled)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            if !type.canAutoComplete {
                Button {
                    finishInput(with: input)
                } label: {
                    Text("ok".localized())
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isDisabled)
                .padding(.horizontal, 40)
                .padding(.vertical)
            }
        }
        .tint(tintColor)
        .onChange(of: input) { text in
            switch type {
            case let .numeric(count):
                guard text.count == count else { return }
                finishInput(with: text)
            case .customNumeric, .alphanumeric:
                return
            }
        }
    }
    
    func biometryAction(_ isEnabled: Bool, action: @escaping () async -> Void) -> Self {
        var view = self
        if isEnabled {
            view.biometryAction = action
        } else {
            view.biometryAction = nil
        }
        return view
    }
    
    func finishInput(with text: String) {
        isDisabled = true
        
        if check(text) {
            onCompletion(true)
        } else {
            withAnimation(.default) {
                attempts += 1
                
                withAnimation(.default.delay(1)) {
                    input = ""
                    isDisabled = false
                }
            }
        }
    }
}

extension InternalPasscodeInputView where Options == EmptyView {
    init(
        type: PasscodeType,
        canCancel: Bool,
        check: @escaping (String) -> Bool,
        onCompletion: @escaping (Bool) -> Void,
        biometryAction: (() async -> Void)? = nil,
        @ViewBuilder hint: () -> Hint
    ) {
        self.type = type
        self.canCancel = canCancel
        self.check = check
        self.onCompletion = onCompletion
        self.biometryAction = biometryAction
        self.hint = hint()
        self.options = EmptyView()
    }
}

struct PasscodeInputView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PasscodeInputView(type: .numeric(4)) { _ in
                return false
            } onCompletion: { _ in
                
            }
        }
        .previewDisplayName("Numeric (Default)")
        
        NavigationView {
            PasscodeInputView(type: .customNumeric) { _ in
                return false
            } onCompletion: { _ in
                
            }
        }
        .previewDisplayName("Numeric (Custom)")
        
        NavigationView {
            PasscodeInputView(type: .alphanumeric) { _ in
                return false
            } onCompletion: { _ in
                
            }
        }
        .environment(\.passcode.tintColor, .yellow)
        .previewDisplayName("Alphanumeric")
    }
}
