//
//  TaskButton.swift
//  PasscodeKit
//
//  Created by David Walter on 13.10.23.
//

import SwiftUI

struct TaskButton<Label>: View where Label: View {
    var action: @Sendable () async -> Void
    var label: (Bool) -> Label

    @State private var isRunning = false
    @State private var task: Task<Void, Never>?

    init(
        action: @MainActor @Sendable @escaping () async -> Void,
        @ViewBuilder label: @escaping (_ isRunning: Bool) -> Label
    ) {
        self.action = action
        self.label = label
    }

    var body: some View {
        Button {
            self.isRunning = true
            self.task = Task {
                await action()
                self.isRunning = false
            }
        } label: {
            label(isRunning)
        }
        .animation(.default, value: isRunning)
        .disabled(isRunning)
        .onDisappear {
            task?.cancel()
        }
    }
}
