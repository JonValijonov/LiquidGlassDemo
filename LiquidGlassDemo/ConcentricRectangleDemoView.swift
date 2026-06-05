//
//  ConcentricRectangleDemoView.swift
//  LiquidGlassDemo
//

import SwiftUI

struct ConcentricRectangleDemoView: View {
    var body: some View {
        List {
            Section {
                ConcentricRectangle()
                    .fill(.tint)
                    .frame(height: 100)
            } header: {
                title("#1 init()")
            } footer: {
                Text("Default — every corner resolves concentrically against the section's corner radius.")
            }

            Section {
                ConcentricRectangle(corners: .concentric)
                    .fill(.tint)
                    .frame(height: 100)
            } header: {
                title("#2 init(corners: .concentric)")
            } footer: {
                Text("Explicit form of concentric — visually identical to #1 in this uniform layout.")
            }

            Section {
                ConcentricRectangle(corners: .concentric, isUniform: false)
                    .fill(.tint)
                    .padding(.top, 4)
                    .padding(.bottom, 36)
                    .frame(height: 140)
            } header: {
                title("#3a isUniform: false (asymmetric padding)")
            } footer: {
                Text("Top corners sit 4pt from the section's top corner → resolve large. Bottom corners sit 36pt away → resolve toward 0. Top and bottom radii differ.")
            }

            Section {
                ConcentricRectangle(corners: .concentric, isUniform: true)
                    .fill(.tint)
                    .padding(.top, 4)
                    .padding(.bottom, 36)
                    .frame(height: 140)
            } header: {
                title("#3b isUniform: true (same asymmetric padding)")
            } footer: {
                Text("Same geometry as #3a — but isUniform:true picks the LARGEST resolved radius and applies it to all four corners, giving symmetry.")
            }

            Section {
                ConcentricRectangle(corners: .fixed(0))
                    .fill(.tint)
                    .frame(height: 100)
            } header: {
                title("#4 init(corners: .fixed(0))")
            } footer: {
                Text("Sharp 0pt corners — non-concentric fallback ignores the container.")
            }

            Section {
                ConcentricRectangle(
                    topLeadingCorner: .concentric,
                    topTrailingCorner: .fixed(0),
                    bottomLeadingCorner: .fixed(0),
                    bottomTrailingCorner: .concentric
                )
                .fill(.tint)
                .frame(height: 100)
            } header: {
                title("#5 Independent per-corner")
            } footer: {
                Text("Top-leading and bottom-trailing concentric; the other two sharp.")
            }

            Section {
                ConcentricRectangle(
                    uniformTopCorners: .concentric,
                    uniformBottomCorners: .fixed(0)
                )
                .fill(.tint)
                .frame(height: 100)
            } header: {
                title("#6 uniformTopCorners / uniformBottomCorners")
            } footer: {
                Text("Concentric on top, sharp on bottom — sheet-card silhouette.")
            }

            Section {
                ConcentricRectangle(
                    uniformLeadingCorners: .fixed(0),
                    uniformTrailingCorners: .concentric
                )
                .fill(.tint)
                .frame(height: 100)
            } header: {
                title("#7 uniformLeadingCorners / uniformTrailingCorners")
            } footer: {
                Text("Sharp leading edge, concentric trailing — attached-pill silhouette.")
            }

            Section {
                ConcentricRectangle(corners: .concentric(minimum: .fixed(20)))
                    .fill(.tint)
                    .padding(40)
                    .frame(height: 180)
            } header: {
                title("#8 .concentric(minimum: .fixed(20))")
            } footer: {
                Text("Heavy 40pt padding pushes the corners too far from the section corners — plain .concentric would resolve to 0. The minimum holds the radius at 20pt.")
            }

            Section {
                Color.clear
                    .frame(height: 100)
                    .background(.tint, in: .rect(corners: .concentric))
            } header: {
                title("#9 .rect(corners: .concentric) — Shape factory")
            } footer: {
                Text("Same concentric behaviour applied via .background(_, in:) with the Shape factory.")
            }

            Section {
                Color.clear
                    .background(
                        .tint,
                        in: .rect(corners: .concentric(minimum: .fixed(10)))
                    )
                    .frame(height: 100)
                    .padding(40)
                    
            } header: {
                title("#10 .rect(corners: .concentric(minimum: .fixed(10)))")
            } footer: {
                Text("Shape-factory variant with a minimum-radius floor — useful when the resolved concentric radius would drop to 0.")
            }

            Section {
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { i in
                        Rectangle()
                            .fill(.tint.opacity(0.55 + Double(i) * 0.15))
                            .aspectRatio(1, contentMode: .fit)
                            .clipShape(ConcentricRectangle())
                    }
                }
            } header: {
                title("#11 Real-world: photo strip")
            } footer: {
                Text("Apple's canonical example — thumbnails clip to a ConcentricRectangle and inherit the section's corner radius automatically.")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("ConcentricRectangle")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func title(_ string: String) -> some View {
        Text(string)
            .font(.system(.subheadline, design: .monospaced).weight(.semibold))
            .textCase(nil)
    }
}

#Preview {
    NavigationStack {
        ConcentricRectangleDemoView()
    }
}
