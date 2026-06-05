//
//  UIKitTabBarDemoView.swift
//  LiquidGlassDemo
//

import SwiftUI
import UIKit

/// A `UITabBarController` wrapped for SwiftUI. Reuses the three SwiftUI tab
/// views from `TabBarDemoView` (Profile, Badges, Impact) but drives them
/// through a UIKit tab bar — useful to compare the two integration paths
/// under iOS 26's Liquid Glass.
///
/// Shares the same global `UITabBar.appearance()` config as the SwiftUI demo
/// so the styling (green deselected, red selected, bold 14pt) carries over.
struct UIKitTabBarDemoView: UIViewControllerRepresentable {
    init() {
        UITabBar.installSharedAppearance()
    }

    func makeUIViewController(context: Context) -> UITabBarController {
        let profile = UIHostingController(rootView: ProfileTab())
        profile.tabBarItem = Self.makeItem(title: "Profile", systemImage: "person.crop.circle", tag: 0)

        let badges = UIHostingController(rootView: BadgesTab())
        badges.tabBarItem = Self.makeItem(title: "Badges", systemImage: "rosette", tag: 1)

        let impact = UIHostingController(rootView: ImpactTab())
        impact.tabBarItem = Self.makeItem(title: "Impact", systemImage: "chart.line.uptrend.xyaxis", tag: 2)

        let tabBar = BlurredTabBarController()
        tabBar.viewControllers = [profile, badges, impact]
        return tabBar
    }

    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {}

    /// Builds a tab item with pre-tinted `.alwaysOriginal` bitmaps so the
    /// Liquid Glass bar can't re-template the SF Symbols. Same trick the
    /// SwiftUI demo uses via `Image(uiImage:)`.
    private static func makeItem(title: String, systemImage: String, tag: Int) -> UITabBarItem {
        let normal = UIImage(systemName: systemImage)?
            .withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        let selected = UIImage(systemName: systemImage)?
            .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        return UITabBarItem(title: title, image: normal, selectedImage: selected)
    }
}

#Preview {
    UIKitTabBarDemoView()
}
