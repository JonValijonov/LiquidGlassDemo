//
//  VariableBlurView.swift
//  LiquidGlassDemo
//

import SwiftUI
import UIKit

/// True progressive Gaussian blur via the private `CAFilter("variableBlur")`
/// API.
///
/// `UIVisualEffectView` ships with a `gaussianBlur` filter on its backdrop
/// layer at a fixed radius. We swap it for a `variableBlur` whose per-pixel
/// radius is driven by a gradient mask image's alpha channel — the result
/// is a Gaussian blur whose strength ramps along the gradient direction.
///
/// ⚠️ `CAFilter` is a private Core Animation API. Apps shipping this have
/// historically passed App Review (Apple uses it in their own apps and
/// the public method names haven't changed in a decade) but the risk is
/// non-zero.
struct VariableBlurView: UIViewRepresentable {
    enum Direction {
        /// Crisp at top → blurry at bottom. Use for fades behind a bottom tab bar.
        case blurredAtBottom
        /// Blurry at top → crisp at bottom. Use for fades behind a top toolbar.
        case blurredAtTop
    }

    let maxRadius: CGFloat
    let direction: Direction

    init(maxRadius: CGFloat = 10, direction: Direction = .blurredAtBottom) {
        self.maxRadius = maxRadius
        self.direction = direction
    }

    func makeUIView(context: Context) -> VariableBlurUIView {
        VariableBlurUIView(maxRadius: maxRadius, direction: direction)
    }

    func updateUIView(_ uiView: VariableBlurUIView, context: Context) {}
}

// MARK: - UIKit backing view

final class VariableBlurUIView: UIVisualEffectView {
    private let maxRadius: CGFloat
    private let direction: VariableBlurView.Direction

    init(maxRadius: CGFloat, direction: VariableBlurView.Direction) {
        self.maxRadius = maxRadius
        self.direction = direction
        super.init(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        installVariableBlur()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }

    /// Swap `UIVisualEffectView`'s default fixed-radius blur for a
    /// `variableBlur` driven by a gradient mask.
    private func installVariableBlur() {
        guard let backdropLayer = subviews.first?.layer else { return }
        guard let filter = makeVariableBlurFilter() else { return }
        backdropLayer.filters = [filter]
    }

    private func makeVariableBlurFilter() -> NSObject? {
        // CAFilter is private — bridge via NSClassFromString + class-method perform.
        guard let cls = NSClassFromString("CAFilter") as AnyObject?,
              let unmanaged = cls.perform(
                NSSelectorFromString("filterWithName:"),
                with: "variableBlur" as NSString
              ),
              let filter = unmanaged.takeUnretainedValue() as? NSObject
        else { return nil }

        filter.setValue(maxRadius, forKey: "inputRadius")
        filter.setValue(makeMaskImage(), forKey: "inputMaskImage")
        filter.setValue(true, forKey: "inputNormalizeEdges")
        return filter
    }

    /// Vertical gradient with alpha controlling per-pixel blur strength.
    private func makeMaskImage() -> CGImage {
        let size = CGSize(width: 100, height: 400)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            let cg = context.cgContext
            let (top, bottom) = directionColors
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: [top, bottom] as CFArray,
                locations: nil
            )!
            cg.drawLinearGradient(
                gradient,
                start: .zero,
                end: CGPoint(x: 0, y: size.height),
                options: []
            )
        }
        return image.cgImage!
    }

    private var directionColors: (CGColor, CGColor) {
        switch direction {
        case .blurredAtBottom:
            return (UIColor.clear.cgColor, UIColor.black.cgColor)
        case .blurredAtTop:
            return (UIColor.black.cgColor, UIColor.clear.cgColor)
        }
    }
}
