//
//  PasscodeSetupView.swift
//  PasscodeUI
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI
import PasscodeModel

public struct PasscodeSetupView: View {
    @Environment(\.dismiss) private var dismiss
    
    var type: PasscodeType
    var onCompletion: (Passcode) -> Void
    
    @State private var code = ""
    @State private var showNext = false
    
    @State private var input1 = ""
    @State private var input2 = ""
    
    @State private var numberOfAttempts = 0
    @State private var isDisabled = false
    
    @State private var task: Task<Void, Never>?
    
    public init(
        type: PasscodeType,
        onCompletion: @escaping (Passcode) -> Void
    ) {
        self.type = type
        self.onCompletion = onCompletion
    }
    
    public var body: some View {
        ZStack {
            if !showNext {
                inputView
                    .zIndex(0)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            }
            
            if showNext {
                reEnterInputView
                    .zIndex(1)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
            }
        }
        .animation(.default, value: showNext)
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
            showNext = true
        } hint: {
            if numberOfAttempts > 0 {
                Text("passcode.enter.failed.hint".localized())
            } else {
                Text("passcode.enter.hint".localized())
            }
        }
    }
    
    var reEnterInputView: some View {
        InternalPasscodeInputView(type: type, canCancel: false) { code in
            if self.code == code {
                return true
            } else {
                return fail()
            }
        } onCompletion: { success in
            onCompletion(Passcode(code, type: type))
        } hint: {
            Text("passcode.enter.again.hint".localized())
        }
        .onDisappear {
            task?.cancel()
        }
    }
    
    func fail() -> Bool {
        withAnimation(.default) {
            showNext = false
            numberOfAttempts += 1
            
            self.task = Task { @MainActor in
                do {
                    try await Task.sleep(nanoseconds: NSEC_PER_SEC)
                    withAnimation(.default) {
                        reset()
                    }
                } catch {
                    reset()
                }
            }
        }
        
        return false
    }
    
    func reset() {
        input1 = ""
        input2 = ""
        isDisabled = false
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
