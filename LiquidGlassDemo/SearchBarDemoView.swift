//
//  SearchBarDemoView.swift
//  LiquidGlassDemo
//
//  Created by Jon Valijonov on 11/06/2026.
//

import SwiftUI
import MapKit

struct SearchBarDemoView: View {
    @State private var searchText = "Houston"
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 39.5501, longitude: -105.7821),
            span: MKCoordinateSpan(latitudeDelta: 18, longitudeDelta: 18)
        )
    )

    private let pinCoordinate = CLLocationCoordinate2D(latitude: 39.5501, longitude: -105.7821)
    private let accent = Color(red: 0.93, green: 0.10, blue: 0.18)

    var body: some View {
        Map(position: $position) {
            Annotation("", coordinate: pinCoordinate) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.white, accent)
                    .shadow(radius: 2, y: 1)
            }
        }
        .mapStyle(.standard)
        .ignoresSafeArea(edges: .bottom)
        .safeAreaInset(edge: .bottom) {
            resultCard
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
        }
        .navigationTitle("Search Location")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(accent, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .searchable(text: $searchText, prompt: "Search")
        .searchPresentationToolbarBehavior(.avoidHidingContent)
    }

    private var resultCard: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Houston, TX")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.primary)
                Text("United States")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(accent)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    NavigationStack {
        SearchBarDemoView()
    }
}
