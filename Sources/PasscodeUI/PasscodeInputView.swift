//
//  PasscodeInputView.swift
//  PasscodeUI
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI
import PasscodeModel

public struct PasscodeInputView<Hint>: View where Hint: View {
    var type: PasscodeType
    var canCancel: Bool
    var check: (String) -> Bool
    var onCompletion: (Bool) -> Void
    @ViewBuilder var hint: () -> Hint
    
    public init(
        passcode: Passcode,
        canCancel: Bool = false,
        onCompletion: @escaping (Bool) -> Void,
        @ViewBuilder hint: @escaping () -> Hint
    ) {
        self.type = passcode.type
        self.canCancel = canCancel
        self.check = { passcode.code == $0 }
        self.onCompletion = onCompletion
        self.hint = hint
    }
    
    public init(
        type: PasscodeType,
        canCancel: Bool = false,
        check: @escaping (String) -> Bool,
        onCompletion: @escaping (Bool) -> Void,
        @ViewBuilder hint: @escaping () -> Hint
    ) {
        self.type = type
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
        .navigationTitle("passcode.title".localized())
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
}

extension PasscodeInputView where Hint == EmptyView {
    public init(
        type: PasscodeType,
        canCancel: Bool = false,
        check: @escaping (String) -> Bool,
        onCompletion: @escaping (Bool) -> Void
    ) {
        self.type = type
        self.canCancel = canCancel
        self.check = check
        self.onCompletion = onCompletion
        self.hint = { EmptyView() }
    }
    
    public init(
        passcode: Passcode,
        canCancel: Bool = false,
        onCompletion: @escaping (Bool) -> Void
    ) {
        self.type = passcode.type
        self.canCancel = canCancel
        self.check = { passcode.code == $0 }
        self.onCompletion = onCompletion
        self.hint = { EmptyView() }
    }
}

struct InternalPasscodeInputView<Hint>: View where Hint: View {
    var type: PasscodeType
    var canCancel: Bool
    var check: (String) -> Bool
    var onCompletion: (Bool) -> Void
    @ViewBuilder var hint: () -> Hint
    
    @State private var input = ""
    @State private var passcode = ""
    @State private var attempts = 0
    @State private var isDisabled = false
    
    @FocusState private var alphaNumericInput
    
    public var body: some View {
        PasscodeScrollView {
            Spacer()
            
            VStack(spacing: 20) {
                hint()
                
                CodeView(text: input, type: type)
                    .modifier(Shake(animatableData: attempts))
                    .background {
                        if type.isAlphaNumeric {
                            TextField("", text: $input)
                                .focused($alphaNumericInput)
                                .onAppear {
                                    alphaNumericInput = true
                                }
                                .allowsHitTesting(false)
                                .accessibilityHidden(true)
                                .opacity(0)
                        }
                    }
            }
            if type.isNumeric {
                Spacer()
                
                KeypadView(text: $input.max(type.maxInputLength))
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 40)
                    .disabled(isDisabled)
            }
            
            Spacer()
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
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
            }
        }
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
    
    func finishInput(with text: String) {
        isDisabled = true
        
        if check(text) {
            onCompletion(true)
        } else {
            withAnimation(.default) {
                attempts += 1
                
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: NSEC_PER_SEC)
                    withAnimation(.default) {
                        input = ""
                        isDisabled = false
                    }
                }
            }
        }
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
        
        NavigationView {
            PasscodeInputView(type: .customNumeric) { _ in
                return false
            } onCompletion: { _ in
                
            }
        }
        
        NavigationView {
            PasscodeInputView(type: .alphanumeric) { _ in
                return false
            } onCompletion: { _ in
                
            }
        }
    }
}
