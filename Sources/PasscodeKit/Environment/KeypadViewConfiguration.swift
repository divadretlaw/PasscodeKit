//
//  KeypadViewConfiguration.swift
//  PasscodeKit
//
//  Created by David Walter on 02.09.23.
//

import SwiftUI
import PasscodeCore

/// Customize the keypad view
public struct KeypadViewConfiguration {
    var foregroundColor: Color = .primary
    var hSpacing: CGFloat = 40
    var vSpacing: CGFloat = 20
    var deleteImage = Image(systemName: "delete.left")
    
    /// Configures the foreground color.
    /// - Parameter color: The color to use.
    /// - Returns: The configuration with the foreground color configured.
    func foregroundColor(_ color: Color) -> Self {
        var configuration = self
        configuration.foregroundColor = color
        return configuration
    }
    
    /// Sets the spacing between the button.
    /// - Parameters:
    ///   - vertical: The vertical spacing.
    ///   - horizontal: The horizontal spacing.
    /// - Returns: The configuration with the spacing configured.
    func spacing(vertical: CGFloat? = nil, horizontal: CGFloat? = nil) -> Self {
        var configuration = self
        if let vertical = vertical {
            configuration.vSpacing = vertical
        }
        if let horizontal = horizontal {
            configuration.hSpacing = horizontal
        }
        return configuration
    }
    
    /// Configures the image for the delete button.
    /// - Parameter image: The name of the system symbol image to use.
    /// - Returns: The configuration with the delete image configured.
    func delete(systemName: String) -> Self {
        var configuration = self
        configuration.deleteImage = Image(systemName: systemName)
        return configuration
    }
    
    /// Configures the image for the delete button.
    /// - Parameter image: The name of the system symbol image to use.
    /// - Returns: The configuration with the delete image configured.
    func delete(image: Image) -> Self {
        var configuration = self
        configuration.deleteImage = image
        return configuration
    }
}

public extension PasscodeEnvironmentValues {
    var keypadViewConfiguration: KeypadViewConfiguration {
        get { self[KeypadViewConfigurationKey.self] }
        set { self[KeypadViewConfigurationKey.self] = newValue }
    }
}

private struct KeypadViewConfigurationKey: EnvironmentKey {
    static var defaultValue: KeypadViewConfiguration {
        KeypadViewConfiguration()
    }
}
