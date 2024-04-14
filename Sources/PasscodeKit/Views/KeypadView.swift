//
//  KeypadView.swift
//  PasscodeKit
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI
import LocalAuthentication

struct KeypadView: View {
    @Environment(\.passcode.keypadViewConfiguration) private var configuration
    
    @Binding var text: String
    var biometryAction: (() async -> Void)?
    
    @ScaledMetric
    private var buttonSize: CGFloat = 80
    
    var body: some View {
        VStack(alignment: .center, spacing: configuration.vSpacing) {
            HStack(spacing: configuration.hSpacing) {
                NumberButton(value: .text("1"), text: $text)
                NumberButton(value: .text("2"), text: $text)
                NumberButton(value: .text("3"), text: $text)
            }
            HStack(spacing: configuration.hSpacing) {
                NumberButton(value: .text("4"), text: $text)
                NumberButton(value: .text("5"), text: $text)
                NumberButton(value: .text("6"), text: $text)
            }
            HStack(spacing: configuration.hSpacing) {
                NumberButton(value: .text("7"), text: $text)
                NumberButton(value: .text("8"), text: $text)
                NumberButton(value: .text("9"), text: $text)
            }
            HStack(spacing: configuration.hSpacing) {
                if let biometricsImage = biometricsImage, let biometryAction = biometryAction {
                    TaskButton {
                        await biometryAction()
                    } label: { _ in
                        ZStack {
                            Image(systemName: biometricsImage)
                                .font(.title)
                                .foregroundColor(configuration.foregroundColor)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .foregroundStyle(.primary)
                        .background(.ultraThinMaterial.blendMode(.multiply))
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: buttonSize, maxHeight: buttonSize)
                    .clipShape(Circle())
                } else {
                    NumberButton(value: .blank, text: $text)
                        .hidden()
                        .disabled(true)
                }
                NumberButton(value: .text("0"), text: $text)
                NumberButton(value: .delete, text: $text)
            }
        }
    }
    
    var biometricsImage: String? {
        switch LAContext().biometryType {
        case .faceID:
            return "faceid"
        case .touchID:
            return "touchid"
        default:
            return nil
        }
    }
}

private struct NumberButton: View {
    @Environment(\.passcode.keypadViewConfiguration) private var configuration
    
    let value: PasscodeInputValue
    @Binding var text: String
    
    @ScaledMetric
    private var buttonSize: CGFloat = 80
    
    var body: some View {
        Button {
            switch value {
            case let .text(string):
                text = text.appending(string)
            case .delete:
                text = String(text.dropLast(1))
            case .blank:
                break
            }
        } label: {
            ZStack {
                display
                    .foregroundColor(configuration.foregroundColor)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .foregroundStyle(.primary)
            .background(.ultraThinMaterial.blendMode(.multiply))
        }
        .buttonStyle(.plain)
        .frame(maxWidth: buttonSize, maxHeight: buttonSize)
        .clipShape(Circle())
    }
    
    @ViewBuilder
    var display: some View {
        switch value {
        case let .text(value):
            Text(value)
                .font(.title)
        case .delete:
            configuration.deleteImage
                .font(.title)
        default:
            EmptyView()
        }
    }
}

enum PasscodeInputValue: Hashable {
    case text(String)
    case delete
    case blank
}

struct KeypadView_Previews: PreviewProvider {
    static var previews: some View {
        KeypadView(text: .constant(""))
        
        KeypadView(text: .constant("")) {
            
        }
    }
}
