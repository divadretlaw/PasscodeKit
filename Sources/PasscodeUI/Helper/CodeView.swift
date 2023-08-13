//
//  CodeView.swift
//  PasscodeUI
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI
import PasscodeModel

struct CodeView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    var passcode: Passcode
    
    init(passcode: Passcode) {
        self.passcode = passcode
    }
    
    init(text: String, type: PasscodeType) {
        self.passcode = Passcode(text, type: type)
    }
    
    var body: some View {
        Group {
            switch passcode.type {
            case let .numeric(count):
                if count <= 6 {
                    bulletView(for: count)
                } else {
                    fieldView
                }
            default:
                fieldView
            }
        }
        .dynamicTypeSize(computedDynamicTypeSize)
    }
    
    func bulletView(for count: Int) -> some View {
        HStack(spacing: 20) {
            ForEach(0 ..< count, id: \.self) { index in
                if index < passcode.code.count {
                    Image(systemName: "circle.fill")
                } else {
                    Image(systemName: "circle")
                }
            }
        }
    }
    
    var fieldView: some View {
        HStack {
            if passcode.isEmpty {
                Image(systemName: "circle").hidden()
            } else {
                ForEach(0 ..< passcode.code.count, id: \.self) { index in
                    if index < passcode.code.count {
                        Image(systemName: "circle.fill")
                    } else {
                        Image(systemName: "circle")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
        }
        .padding(.horizontal, 40)
    }
    
    // The accessibility sizes easily clip the code view out of
    // the view and provide no real benefit by having a larger
    // size, as there is no real content to read.
    //
    // Therefore we limit the `dynamicTypeSize` to `.xxxLarge`
    private var computedDynamicTypeSize: DynamicTypeSize {
        if dynamicTypeSize.isAccessibilitySize {
            return .xxxLarge
        } else {
            return dynamicTypeSize
        }
    }
    
}

struct CodeView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 30) {
                Section {
                    CodeView(passcode: Passcode("", type: .numeric(4)))
                    CodeView(passcode: Passcode("1", type: .numeric(4)))
                    CodeView(passcode: Passcode("12", type: .numeric(4)))
                    CodeView(passcode: Passcode("123", type: .numeric(4)))
                    CodeView(passcode: Passcode("1234", type: .numeric(4)))
                } header: {
                    Text("Fixed Numeric")
                }
                Section {
                    CodeView(text: "123456722", type: .numeric(123))
                    CodeView(text: "123456789", type: .customNumeric)
                } header: {
                    Text("Custom Numeric")
                }
                Section {
                    CodeView(text: "", type: .alphanumeric)
                    CodeView(text: "asdf", type: .alphanumeric)
                } header: {
                    Text("Alphanumeric")
                }
            }
        }
    }
}
