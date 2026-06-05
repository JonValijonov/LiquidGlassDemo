//
//  BlurredTabBarController.swift
//  LiquidGlassDemo
//

import UIKit

/// A `UITabBarController` that slips a 174pt-tall thin-material blur strip
/// behind its tab bar. The blur sits anchored to the bottom of the view,
/// inserted below the tab bar in z-order so the Liquid Glass bar still
/// renders on top.
final class BlurredTabBarController: UITabBarController {
    private let blurHeight: CGFloat = 174

    private lazy var blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        view.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(blurView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        blurView.frame = CGRect(
            x: 0,
            y: view.bounds.height - blurHeight,
            width: view.bounds.width,
            height: blurHeight
        )
        // Find the subview that hosts the tab bar (the bar itself on older
        // iOS, or its iOS 26 wrapper) and promote it above the blur.
        if let container = view.subviews.first(where: { tabBar.isDescendant(of: $0) }) {
            view.bringSubviewToFront(container)
        }
    }
}
