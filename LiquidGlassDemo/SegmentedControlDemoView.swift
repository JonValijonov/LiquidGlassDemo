//
//  SegmentedControlDemoView.swift
//  LiquidGlassDemo
//

import SwiftUI

// MARK: - Tokens (from the Blood Donor design system)

private let arcRed = Color(red: 231/255, green: 19/255, blue: 36/255)
private let arcGrey = Color(red: 109/255, green: 110/255, blue: 112/255)
private let arcGrey3 = Color(red: 246/255, green: 246/255, blue: 246/255)
private let arcDarkStart = Color(red: 88/255, green: 88/255, blue: 88/255)
private let arcDarkEnd = Color(red: 44/255, green: 44/255, blue: 44/255)
private let arcGreen = Color(red: 76/255, green: 187/255, blue: 53/255)

// MARK: - Screen

struct SegmentedControlDemoView: View {
    @State private var selection = 0

    private let teams: [(String, Int)] = [
        ("Massachusetts Institute of Technology", 86_000),
        ("Stanford University", 74_300),
        ("Harvard University", 68_900),
        ("University of Cambridge", 61_200),
        ("California Institute of Technology", 54_700),
        ("ETH Zürich", 48_100),
        ("Imperial College London", 41_500),
        ("University of Oxford", 36_800),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                header
                infoBanner
                teamsList
            }
        }
        .background(arcGrey3)
        .ignoresSafeArea(edges: .top)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    // MARK: Header

    private var header: some View {
        VStack(spacing: 17) {
            PillSegmentedControl(
                selection: $selection,
                options: ["My Team", "Standings"]
            )
            .padding(.top, 64) // clear status bar / nav back button

            orgRow
                .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [arcDarkStart, arcDarkEnd],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
        )
    }

    private var orgRow: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(arcGreen)
                Image(systemName: "cube.fill")
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .bold))
            }
            .frame(width: 40, height: 40)

            Text("3 SIDED CUBE")
                .font(.system(size: 15, weight: .heavy))
                .foregroundStyle(.white)
                .lineLimit(2)
                .frame(width: 125, alignment: .leading)

            Spacer()

            statColumn(label: "RANK", value: "114.0K")
            statColumn(label: "TEAMS", value: "32k")
        }
        .padding(.horizontal, 16)
    }

    private func statColumn(label: String, value: String) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 1.5)
                .fill(.white.opacity(0.2))
                .frame(width: 3, height: 32)
            VStack(alignment: .leading, spacing: 0) {
                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .tracking(0.79)
                    .foregroundStyle(.white)
                Text(value)
                    .font(.system(size: 21, weight: .heavy))
                    .foregroundStyle(.white)
            }
        }
    }

    // MARK: Info banner

    private var infoBanner: some View {
        Text("Each donation can help save more than one life")
            .font(.system(size: 13, weight: .bold))
            .foregroundStyle(.black)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 15)
            .padding(.vertical, 16)
            .background(.white)
    }

    // MARK: Teams list

    private var teamsList: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Teams (By Impact)")
                    .font(.system(size: 13))
                    .foregroundStyle(arcGrey)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background(arcGrey3)

            ForEach(Array(teams.enumerated()), id: \.offset) { index, team in
                teamRow(rank: index + 1, name: team.0, lives: team.1)
            }
        }
    }

    private func teamRow(rank: Int, name: String, lives: Int) -> some View {
        HStack(spacing: 15) {
            Text("\(rank)")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .background(arcGrey, in: .rect(cornerRadius: 6))

            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.08), radius: 6, y: 4)
                Image(systemName: "person.3.fill")
                    .foregroundStyle(arcRed)
                    .font(.system(size: 26))
            }
            .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                Text("\(lives.formatted()) lives")
                    .font(.system(size: 13))
                    .foregroundStyle(arcGrey)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(arcRed)
                .font(.system(size: 14, weight: .semibold))
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 16)
        .frame(height: 100)
        .background(.white)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(arcGrey3)
                .frame(height: 2)
        }
    }
}

// MARK: - Pill segmented control

private struct PillSegmentedControl: View {
    @Binding var selection: Int
    let options: [String]
    @Namespace private var ns

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<options.count, id: \.self) { i in
                segment(at: i)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .frame(width: 260, height: 44)
        .background(Capsule().fill(.white.opacity(0.2)))
        .background(.thinMaterial, in: .capsule)
    }

    private func segment(at i: Int) -> some View {
        let isSelected = i == selection
        return ZStack {
            if isSelected {
                Capsule()
                    .fill(.white)
                    .matchedGeometryEffect(id: "selection", in: ns)
            }
            Text(options[i])
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(isSelected ? Color.black : Color.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity, minHeight: 36)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                selection = i
            }
        }
    }
}

#Preview {
    NavigationStack {
        SegmentedControlDemoView()
    }
}
