//
//  KeypadView.swift
//  PasscodeUI
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI

struct KeypadView: View {
    @Binding var text: String
    var vSpacing: CGFloat? = 20
    var hSpacing: CGFloat? = 40
    
    var body: some View {
        VStack(alignment: .center, spacing: vSpacing) {
            HStack(spacing: hSpacing) {
                NumberButton(value: .text("1"), text: $text)
                NumberButton(value: .text("2"), text: $text)
                NumberButton(value: .text("3"), text: $text)
            }
            HStack(spacing: hSpacing) {
                NumberButton(value: .text("4"), text: $text)
                NumberButton(value: .text("5"), text: $text)
                NumberButton(value: .text("6"), text: $text)
            }
            HStack(spacing: hSpacing) {
                NumberButton(value: .text("7"), text: $text)
                NumberButton(value: .text("8"), text: $text)
                NumberButton(value: .text("9"), text: $text)
            }
            HStack(spacing: hSpacing) {
                NumberButton(value: .blank, text: $text)
                    .hidden()
                    .disabled(true)
                NumberButton(value: .text("0"), text: $text)
                NumberButton(value: .delete, text: $text)
            }
        }
    }
}

private struct NumberButton: View {
    let value: PasscodeInputValue
    @Binding var text: String
    
    var body: some View {
        Button {
            switch value {
            case .text(let string):
                text = text.appending(string)
            case .delete:
                text = String(text.dropLast(1))
            case .blank:
                break
            }
        } label: {
            ZStack {
                value.display
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(.thinMaterial)
            .clipShape(Circle())
            .frame(maxWidth: 100, maxHeight: 100)
        }
        .buttonStyle(.plain)
    }
}

enum PasscodeInputValue: Hashable {
    case text(String)
    case delete
    case blank
}

extension PasscodeInputValue {
    @ViewBuilder
    var display: some View {
        switch self {
        case let .text(value):
            Text(value)
                .font(.title)
        case .delete:
            Image(systemName: "delete.left")
                .imageScale(.large)
        default:
            EmptyView()
        }
    }
}

struct KeypadView_Previews: PreviewProvider {
    static var previews: some View {
        KeypadView(text: .constant(""))
    }
}
