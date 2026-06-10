//
//  BlurredTabBarController.swift
//  LiquidGlassDemo
//

import UIKit

/// A `UITabBarController` that slips a "Fade/Gradient" strip behind its tab
/// bar — a BlurUIKit progressive blur (App-Store-safe `CAFilter` copied from a
/// public `UIVisualEffectView` property, not the raw private symbol) with an
/// off-white `#f6f6f6` linear gradient on top, fading from near-solid behind
/// the bar to transparent as it rises into the scrolling content. Matches the
/// Figma `Fade/Gradient` node.
final class BlurredTabBarController: UITabBarController {
    /// Extra space above the tab bar that the fade should also cover, matching
    /// the Figma `TabBar/iOS` container (95pt tall, `pt: 12` / `pb: 21` around
    /// the bar pill) rather than a fixed-height strip. The fade runs from 12pt
    /// above the bar down to the bottom of the screen, so it covers the bar plus
    /// its safe-area padding below. On a notched device this lands at ~95pt
    /// (12 + 49pt bar + 34pt safe area), matching the container height in Figma.
    private let containerPaddingAbove: CGFloat = 12

    /// Container that hosts both the backdrop blur and the gradient overlay
    /// so they move together and share the same frame.
    private lazy var fadeView: UIView = {
        let container = UIView()
        container.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        container.isUserInteractionEnabled = false  // don't swallow taps

        // BlurUIKit progressive blur. `.up` ramps the blur up toward the
        // bottom edge (heavy at bottom, crisp at top). Radius ramps 0 → 4 to
        // match the Figma blur (Figma's value isn't 1:1 with the Core Image
        // radius, so nudge this if it reads too soft/strong on device). Its
        // built-in dimming tint is switched off (`nil`) so the only wash is the
        // exact Figma `#f6f6f6` GradientView below — otherwise the default
        // `.systemBackground` dimming would double up (and go black in dark mode).
        let blur = VariableBlurView()
        blur.direction = .up
        blur.maximumBlurRadius = 0.6
        blur.dimmingTintColor = nil
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        container.addSubview(blur)

        let gradient = GradientView()
        gradient.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        container.addSubview(gradient)

        return container
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(fadeView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Anchor the fade to the tab bar container rather than a fixed height:
        // start `containerPaddingAbove` above the bar's top and run to the
        // bottom of the screen. This wraps the bar plus its padding above and
        // below regardless of the bar's height or the device's safe-area inset.
        let barFrame = tabBar.superview?.convert(tabBar.frame, to: view) ?? tabBar.frame
        let top = barFrame.minY - containerPaddingAbove
        fadeView.frame = CGRect(
            x: 0,
            y: top,
            width: view.bounds.width,
            height: view.bounds.height - top
        )
        // Find the subview that hosts the tab bar (the bar itself on older
        // iOS, or its iOS 26 wrapper) and promote it above the strip.
        if let container = view.subviews.first(where: { tabBar.isDescendant(of: $0) }) {
            view.bringSubviewToFront(container)
        }
    }
}

// MARK: - Gradient

/// `UIView` whose backing layer is a `CAGradientLayer`. Renders the
/// `Fade/Gradient` Figma node — a single `#F6F6F6` colour whose opacity ramps
/// top → bottom: 0% at the top, 85% at 45% down, 95% at the bottom. The wash is
/// near-solid behind the bar and clears as it rises into the scrolling content.
private final class GradientView: UIView {
    override class var layerClass: AnyClass { CAGradientLayer.self }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        guard let gradient = layer as? CAGradientLayer else { return }
        let base = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        gradient.colors = [
            base.withAlphaComponent(0.0).cgColor,
            base.withAlphaComponent(0.75).cgColor,
            base.withAlphaComponent(0.85).cgColor
        ]
        gradient.locations = [0.0, 0.55, 1.0]
        // CAGradientLayer interpolates from `startPoint` (location 0) to
        // `endPoint` (location 1). Top → bottom.
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
    }
}
