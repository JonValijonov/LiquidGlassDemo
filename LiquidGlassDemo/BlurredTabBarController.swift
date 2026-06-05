//
//  BlurredTabBarController.swift
//  LiquidGlassDemo
//

import UIKit

/// A `UITabBarController` that slips a 174pt "Fade/Gradient" strip behind
/// its tab bar — `systemUltraThinMaterial` backdrop blur with an off-white
/// `#f6f6f6` linear gradient on top, fading from solid at the bottom to
/// transparent near the top. Matches the Figma `Fade/Gradient` node.
final class BlurredTabBarController: UITabBarController {
    private let fadeHeight: CGFloat = 120

    /// Container that hosts both the backdrop blur and the gradient overlay
    /// so they move together and share the same frame.
    private lazy var fadeView: UIView = {
        let container = UIView()
        container.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        container.isUserInteractionEnabled = false  // don't swallow taps

        let blur = ProgressiveBlurView()
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
        fadeView.frame = CGRect(
            x: 0,
            y: view.bounds.height - fadeHeight,
            width: view.bounds.width,
            height: fadeHeight
        )
        // Find the subview that hosts the tab bar (the bar itself on older
        // iOS, or its iOS 26 wrapper) and promote it above the strip.
        if let container = view.subviews.first(where: { tabBar.isDescendant(of: $0) }) {
            view.bringSubviewToFront(container)
        }
    }
}

// MARK: - Progressive blur

/// `UIVisualEffectView` masked by a vertical alpha gradient — visually
/// approximates Figma's "Background blur (progressive)" where the blur
/// ramps from 0 at the top to a small radius at the bottom. Stock UIKit
/// can't vary the blur radius itself, so we keep the radius uniform and
/// fade the effect's *visibility* with a CALayer mask. Same intent: no
/// blur up top, full blur at the bottom.
private final class ProgressiveBlurView: UIView {
    private let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    private let maskLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blur)

        // Mask: opaque at top → clear at bottom. Reversed from the
        // earlier setup so the blur sits at the bottom of the strip and
        // fades out toward the top.
        maskLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        maskLayer.startPoint = CGPoint(x: 0.5, y: 1)
        maskLayer.endPoint = CGPoint(x: 0.5, y: 0)
        blur.layer.mask = maskLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // CALayer frame changes inside layoutSubviews shouldn't animate.
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        maskLayer.frame = blur.bounds
        CATransaction.commit()
    }
}

// MARK: - Gradient

/// `UIView` whose backing layer is a `CAGradientLayer`. Renders the
/// `Fade/Gradient` Figma node: `#f6f6f6` solid at the bottom 6.908% →
/// transparent `#f6f6f6` at 79.83% → transparent above.
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
        // TEMP debug colour — swap back to #f6f6f6 once we've confirmed
        // the gradient is rendering. Red is obviously visible.
        let base = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
//        let base = UIColor.blue
        gradient.colors = [
            base.cgColor,
            base.withAlphaComponent(0).cgColor
        ]
        // CAGradientLayer interpolates from `startPoint` (location 0) to
        // `endPoint` (location 1). Bottom → top.
        gradient.startPoint = CGPoint(x: 0.5, y: 1)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        gradient.locations = [0.06908, 0.7983]
    }
}
