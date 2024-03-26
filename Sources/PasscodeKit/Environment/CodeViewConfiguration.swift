//
//  CodeViewConfiguration.swift
//  PasscodeKit
//
//  Created by David Walter on 02.09.23.
//

import PasscodeCore
import SwiftUI

/// Customize the code view
public struct CodeViewConfiguration: Sendable {
    var foregroundColor: Color = .primary
    var emptyImage = Image(systemName: "circle")
    var filledImage = Image(systemName: "circle.fill")
    var spacing: CGFloat = 20
    
    /// Configures the foreground color.
    /// - Parameter color: The color to use.
    /// - Returns: The configuration with the foreground color configured.
    func foregroundColor(_ color: Color) -> Self {
        var configuration = self
        configuration.foregroundColor = color
        return configuration
    }
    
    /// Configures the empty image code point.
    /// - Parameter image: The name of the system symbol image to use as empty code point.
    /// - Returns: The configuration with the empty image configured.
    func empty(systemName: String) -> Self {
        var configuration = self
        configuration.emptyImage = Image(systemName: systemName)
        return configuration
    }
    
    /// Configures the empty image code point.
    /// - Parameter image: The name of the system symbol image to use as empty code point.
    /// - Returns: The configuration with the empty image configured.
    func empty(image: Image) -> Self {
        var configuration = self
        configuration.emptyImage = image
        return configuration
    }
    
    /// Configures the filled image code point.
    /// - Parameter image: The name of the system symbol image to use as filled code point.
    /// - Returns: The configuration with the filled image configured.
    func filled(systemName: String) -> Self {
        var configuration = self
        configuration.filledImage = Image(systemName: systemName)
        return configuration
    }
    
    /// Configures the filled image code point.
    /// - Parameter image: The image to use as filled code point.
    /// - Returns: The configuration with the filled image configured.
    func filled(image: Image) -> Self {
        var configuration = self
        configuration.filledImage = image
        return configuration
    }
    
    /// Configures the spacing between the code points.
    /// - Parameter value: The spacing to use.
    /// - Returns: The configuration with the spacing configured.
    func spacing(_ value: CGFloat) -> Self {
        var configuration = self
        configuration.spacing = value
        return configuration
    }
}

public extension PasscodeEnvironmentValues {
    var codeViewConfiguration: CodeViewConfiguration {
        get { self[CodeViewConfigurationKey.self] }
        set { self[CodeViewConfigurationKey.self] = newValue }
    }
}

private struct CodeViewConfigurationKey: EnvironmentKey {
    static var defaultValue: CodeViewConfiguration {
        CodeViewConfiguration()
    }
}
