# LiquidGlassDemo

A SwiftUI sandbox for iOS 26's Liquid Glass shapes. Each screen walks through one shape's API surface with side-by-side examples and short footnotes explaining why each variant resolves the way it does.

## Requirements

- Xcode 26.1+
- iOS 26.1+ (iPhone or iPad)

## Running

Open `LiquidGlassDemo.xcodeproj` and run the `LiquidGlassDemo` scheme on an iOS 26.1 simulator or device.

## Demos

### ConcentricRectangle

`ConcentricRectangleDemoView` covers eleven cases:

1. `init()` — default concentric behaviour against the enclosing section.
2. `init(corners: .concentric)` — explicit form of #1.
3. `isUniform: false` vs `true` under asymmetric padding — top/bottom radii diverge vs collapse to the largest.
4. `init(corners: .fixed(0))` — non-concentric sharp corners.
5. Independent per-corner radii (`topLeadingCorner:` / `topTrailingCorner:` / …).
6. `uniformTopCorners` / `uniformBottomCorners` — sheet-card silhouette.
7. `uniformLeadingCorners` / `uniformTrailingCorners` — attached-pill silhouette.
8. `.concentric(minimum: .fixed(20))` — minimum-radius floor when padding would otherwise resolve to 0.
9. `.rect(corners: .concentric)` via the `Shape` factory.
10. `.rect(corners: .concentric(minimum: .fixed(10)))` — factory variant with a floor.
11. Photo-strip clip — Apple's canonical example of thumbnails inheriting the section radius.
