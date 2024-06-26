//
//  API.swift
//  PasscodeCore
//
//  Created by David Walter on 12.08.23.
//

import SwiftUI

public extension View {
    /// Automatially present a passcode
    ///
    /// - Parameters:
    ///   - mode: The mode to present the passcode.
    ///   - material: The background material of the passcode view.
    ///   - input: The passcode input view. Call the given `dismiss` action when the passcode was validated.
    ///
    /// - Returns: A view with a passcode enabled.
    @MainActor func passcode<I>(
        mode: PasscodeMode = .default,
        background material: Material? = .regular,
        @ViewBuilder input: @escaping (_ dismiss: DismissPasscodeAction) -> I
    ) -> some View where I: View {
        modifier {
            PasscodeViewModifierHelper(mode: mode, input: input) {
                Color(uiColor: .systemBackground)
                    .modifier(BackgroundMaterialViewModifier(material: material))
            }
        }
    }
    
    /// Automatially present a passcode
    ///
    /// - Parameters:
    ///   - mode: The mode to present the passcode.
    ///   - input: The passcode input view. Call the given `dismiss` action when the passcode was validated.
    ///   - background: The background view of the passcode view.
    /// 
    /// - Returns: A view with a passcode enabled.
    @MainActor func passcode<I, B>(
        mode: PasscodeMode = .default,
        @ViewBuilder input: @escaping (_ dismiss: DismissPasscodeAction) -> I,
        @ViewBuilder background: @escaping () -> B
    ) -> some View where I: View, B: View {
        modifier {
            PasscodeViewModifierHelper(mode: mode, input: input, background: background)
        }
    }
    
    // MARK: Privacy View
    
    /// Automatially present a privacy view
    ///
    /// - Parameters:
    ///   - material: The background material of the  privacy vew.
    ///
    /// - Returns: A view with a privacy view enabled.
    @MainActor func privacyView(
        background material: Material? = .regular
    ) -> some View {
        passcode(mode: .hideInAppSwitcher, background: material) { _ in
            EmptyView()
        }
    }
    
    /// Automatially present a privacy view
    ///
    /// - Parameters:
    ///   - windowScene: The window scene to present the privacy vew on.
    ///   - background: The background view of the privacy view.
    ///
    /// - Returns: A view with a privacy view enabled.
    @MainActor func privacyView<B>(
        @ViewBuilder background: @escaping () -> B
    ) -> some View where B: View {
        passcode(mode: .hideInAppSwitcher) { _ in
            EmptyView()
        } background: {
            background()
        }
    }
}

// MARK: - UIWindowScene

public extension View {
    /// Automatially present a passcode
    ///
    /// - Parameters:
    ///   - windowScene: The window scene to present the passcode on.
    ///   - mode: The mode to present the passcode.
    ///   - material: The background material of the passcode view.
    ///   - input: The passcode input view. Call the given `dismiss` action when the passcode was validated.
    ///
    /// - Returns: A view with a passcode enabled.
    @MainActor func passcode<I>(
        on windowScene: UIWindowScene,
        mode: PasscodeMode = .default,
        background material: Material? = .regular,
        @ViewBuilder input: @escaping (_ dismiss: DismissPasscodeAction) -> I
    ) -> some View where I: View {
        modifier {
            PasscodeViewModifier(windowScene: windowScene, mode: mode, input: input) {
                Color(uiColor: .systemBackground)
                    .modifier(BackgroundMaterialViewModifier(material: material))
            }
        }
    }
    
    /// Automatially present a passcode
    ///
    /// - Parameters:
    ///   - windowScene: The window scene to present the passcode on.
    ///   - mode: The mode to present the passcode.
    ///   - material: The background material of the passcode view.
    ///   - input: The passcode input view. Call the given `dismiss` action when the passcode was validated.
    ///   - background: The background view of the passcode view.
    ///
    /// - Returns: A view with a passcode enabled.
    @MainActor func passcode<I, B>(
        on windowScene: UIWindowScene,
        mode: PasscodeMode = .default,
        @ViewBuilder input: @escaping (_ dismiss: DismissPasscodeAction) -> I,
        @ViewBuilder background: @escaping () -> B
    ) -> some View where I: View, B: View {
        modifier {
            PasscodeViewModifier(windowScene: windowScene, mode: mode, input: input, background: background)
        }
    }
    
    // MARK: Privacy View
    
    /// Automatially present a privacy view
    ///
    /// - Parameters:
    ///   - windowScene: The window scene to present the  privacy vew on.
    ///   - material: The background material of the  privacy vew.
    ///
    /// - Returns: A view with a privacy view enabled.
    @MainActor func privacyView(
        on windowScene: UIWindowScene,
        background material: Material? = .regular
    ) -> some View {
        passcode(on: windowScene, mode: .hideInAppSwitcher, background: material) { _ in
            EmptyView()
        }
    }
    
    /// Automatially present a privacy view
    ///
    /// - Parameters:
    ///   - windowScene: The window scene to present the privacy vew on.
    ///   - background: The background view of the privacy view.
    ///
    /// - Returns: A view with a privacy view enabled.
    @MainActor func privacyView<B>(
        on windowScene: UIWindowScene,
        @ViewBuilder background: @escaping () -> B
    ) -> some View where B: View {
        passcode(on: windowScene, mode: .hideInAppSwitcher) { _ in
            EmptyView()
        } background: {
            background()
        }
    }
}
