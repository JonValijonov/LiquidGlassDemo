//
//  UITabBar+Appearance.swift
//  LiquidGlassDemo
//

import UIKit

extension UITabBar {
    /// Installs the shared tab bar appearance used by both the SwiftUI and
    /// UIKit demos: bold 14pt labels, green deselected items, red (app
    /// accent) selected items, and a transparent background so iOS 26
    /// keeps the bar in its floating Liquid Glass form.
    ///
    /// `UITabBar.appearance()` is a global proxy, so this single call
    /// affects every tab bar in the app.
    static func installSharedAppearance() {
        let font = UIFont.systemFont(ofSize: 10, weight: .bold)

        let normalAttrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.systemGreen,
        ]
        // Keep the bold font on the selected state, but let the tint
        // (the app's AccentColor) drive its colour — no foreground override.
        let selectedAttrs: [NSAttributedString.Key: Any] = [
            .font: font,
        ]

        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()

        for layout in [
            appearance.stackedLayoutAppearance,
            appearance.inlineLayoutAppearance,
            appearance.compactInlineLayoutAppearance,
        ] {
            layout.normal.titleTextAttributes = normalAttrs
            layout.selected.titleTextAttributes = selectedAttrs
            layout.normal.iconColor = .systemGreen
            // Don't set selected.iconColor — system uses the TabView's tint.
        }

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        // Forces unselected SF Symbols green — `layout.normal.iconColor`
        // alone is ignored by the iOS 26 Liquid Glass bar.
        UITabBar.appearance().unselectedItemTintColor = .systemGreen
    }
}
