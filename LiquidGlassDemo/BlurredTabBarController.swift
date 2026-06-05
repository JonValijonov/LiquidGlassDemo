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
    private let fadeHeight: CGFloat = 174

    /// Container that hosts both the backdrop blur and the gradient overlay
    /// so they move together and share the same frame.
    private lazy var fadeView: UIView = {
        let container = UIView()
        container.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        container.isUserInteractionEnabled = false  // don't swallow taps

        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
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
            base.withAlphaComponent(0).cgColor,
            base.cgColor
        ]
        // CAGradientLayer interpolates from `startPoint` (location 0) to
        // `endPoint` (location 1). Bottom → top.
        gradient.startPoint = CGPoint(x: 0.5, y: 1)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        gradient.locations = [0.06908, 0.7983]
    }
}
