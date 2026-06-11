//
//  TabBarDemoView.swift
//  LiquidGlassDemo
//

import SwiftUI
import UIKit

struct TabBarDemoView: View {
    @State private var selection: TabID = .profile

    enum TabID: Hashable {
        case profile, badges, impact
    }

    init() {
        UITabBar.installSharedAppearance()
    }

    var body: some View {
        TabView(selection: $selection) {
            Tab(value: TabID.profile) {
                ProfileTab()
            } label: {
                tabLabel("Profile", systemImage: "person.crop.circle", tab: .profile)
            }

            Tab(value: TabID.badges) {
                BadgesTab()
            } label: {
                tabLabel("Badges", systemImage: "rosette", tab: .badges)
            }

            Tab(value: TabID.impact) {
                ImpactTab()
            } label: {
                tabLabel("Impact", systemImage: "chart.line.uptrend.xyaxis", tab: .impact)
            }
        }
    }

    /// Bakes the SF Symbol into a coloured bitmap with `.alwaysOriginal`
    /// rendering mode so the Liquid Glass bar can't re-template it.
    private func tabLabel(_ title: String, systemImage: String, tab: TabID) -> some View {
        let colour: UIColor = (tab == selection) ? .systemRed : .systemGreen
        let image = UIImage(systemName: systemImage)?
            .withTintColor(colour, renderingMode: .alwaysOriginal)
            ?? UIImage()
        return Label {
            Text(title)
        } icon: {
            Image(uiImage: image)
        }
    }
}

// MARK: - Profile

struct ProfileTab: View {
    private struct Row: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let detail: String?
    }

    private let account: [Row] = [
        .init(icon: "person.text.rectangle", title: "Name", detail: "Jon Valijonov"),
        .init(icon: "at", title: "Username", detail: "@jon"),
        .init(icon: "envelope", title: "Email", detail: "jon@example.com"),
        .init(icon: "phone", title: "Phone", detail: "+44 ••• ••• 4421"),
        .init(icon: "creditcard", title: "Subscription", detail: "Pro"),
        .init(icon: "key", title: "Password", detail: nil),
    ]

    private let notifications: [Row] = [
        .init(icon: "bell.badge", title: "Push notifications", detail: "On"),
        .init(icon: "envelope.badge", title: "Email digest", detail: "Weekly"),
        .init(icon: "iphone.radiowaves.left.and.right", title: "Live activities", detail: "On"),
        .init(icon: "moon.zzz", title: "Quiet hours", detail: "22:00 – 07:00"),
        .init(icon: "speaker.wave.2", title: "Sounds", detail: "Default"),
    ]

    private let privacy: [Row] = [
        .init(icon: "lock.shield", title: "Two-factor auth", detail: "On"),
        .init(icon: "faceid", title: "Biometric unlock", detail: "Face ID"),
        .init(icon: "hand.raised", title: "Blocked accounts", detail: "3"),
        .init(icon: "eye.slash", title: "Hide activity", detail: "Off"),
        .init(icon: "location", title: "Location sharing", detail: "While using"),
        .init(icon: "shield.lefthalf.filled", title: "Data export", detail: nil),
    ]

    private let appearance: [Row] = [
        .init(icon: "paintbrush", title: "Theme", detail: "System"),
        .init(icon: "textformat.size", title: "Text size", detail: "Default"),
        .init(icon: "circle.lefthalf.filled", title: "App icon", detail: "Glass"),
        .init(icon: "rectangle.on.rectangle", title: "Home layout", detail: "Compact"),
        .init(icon: "globe", title: "Language", detail: "English (UK)"),
    ]

    private let support: [Row] = [
        .init(icon: "questionmark.circle", title: "Help centre", detail: nil),
        .init(icon: "bubble.left.and.bubble.right", title: "Contact support", detail: nil),
        .init(icon: "exclamationmark.bubble", title: "Report a problem", detail: nil),
        .init(icon: "star", title: "Rate the app", detail: nil),
        .init(icon: "doc.text", title: "Terms & privacy", detail: nil),
        .init(icon: "info.circle", title: "About", detail: "v1.4.0 (210)"),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    header

                    section("Account", rows: account)
                    section("Notifications", rows: notifications)
                    section("Privacy & Security", rows: privacy)
                    section("Appearance", rows: appearance)
                    section("Support", rows: support)

                    Button(role: .destructive) {} label: {
                        Text("Sign out")
                            .font(.body.weight(.medium))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(.red.opacity(0.12), in: .rect(corners: .concentric(minimum: .fixed(16))))
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 80)
            }
            .navigationTitle("Profile")
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 110, height: 110)
                .foregroundStyle(.tint)
                .padding(.top, 16)

            VStack(spacing: 4) {
                Text("Jon Valijonov")
                    .font(.title2.weight(.semibold))
                Text("Member since 2026 · Pro")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func section(_ title: String, rows: [Row]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .padding(.horizontal, 4)

            VStack(spacing: 8) {
                ForEach(rows) { row in
                    HStack(spacing: 14) {
                        Image(systemName: row.icon)
                            .font(.body)
                            .foregroundStyle(.tint)
                            .frame(width: 28)
                        Text(row.title)
                        Spacer()
                        if let detail = row.detail {
                            Text(detail)
                                .foregroundStyle(.secondary)
                        }
                        Image(systemName: "chevron.right")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 14)
                    .background(.tint.opacity(0.08), in: .rect(corners: .concentric(minimum: .fixed(14))))
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Badges

struct BadgesTab: View {
    private struct Badge: Identifiable {
        let id = UUID()
        let title: String
        let icon: String
        let unlocked: Bool
    }

    private let achievements: [Badge] = [
        .init(title: "Early Adopter", icon: "sparkles", unlocked: true),
        .init(title: "First Post", icon: "square.and.pencil", unlocked: true),
        .init(title: "Top Voter", icon: "hand.thumbsup.fill", unlocked: true),
        .init(title: "Explorer", icon: "map.fill", unlocked: true),
        .init(title: "Collector", icon: "tray.full.fill", unlocked: true),
        .init(title: "Marathoner", icon: "figure.run", unlocked: true),
        .init(title: "Mentor", icon: "graduationcap.fill", unlocked: false),
        .init(title: "Legend", icon: "crown.fill", unlocked: false),
    ]

    private let streaks: [Badge] = [
        .init(title: "Streak: 7", icon: "flame", unlocked: true),
        .init(title: "Streak: 30", icon: "flame.fill", unlocked: true),
        .init(title: "Streak: 100", icon: "flame.circle.fill", unlocked: true),
        .init(title: "Streak: 365", icon: "calendar.badge.checkmark", unlocked: false),
        .init(title: "Comeback", icon: "arrow.uturn.left.circle.fill", unlocked: true),
        .init(title: "Night Owl", icon: "moon.stars.fill", unlocked: true),
        .init(title: "Early Bird", icon: "sun.horizon.fill", unlocked: false),
        .init(title: "Weekend Warrior", icon: "bolt.heart.fill", unlocked: true),
    ]

    private let events: [Badge] = [
        .init(title: "Launch Week", icon: "party.popper.fill", unlocked: true),
        .init(title: "Anniversary", icon: "birthday.cake.fill", unlocked: true),
        .init(title: "Summer Fest", icon: "sun.max.fill", unlocked: true),
        .init(title: "Winter Sprint", icon: "snowflake", unlocked: false),
        .init(title: "Beta Tester", icon: "ant.fill", unlocked: true),
        .init(title: "Bug Hunter", icon: "ladybug.fill", unlocked: true),
        .init(title: "Champion '26", icon: "trophy.fill", unlocked: false),
        .init(title: "Hall of Fame", icon: "star.circle.fill", unlocked: false),
    ]

    private let columns = [GridItem(.adaptive(minimum: 140), spacing: 14)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    summary

                    group("Achievements", badges: achievements)
                    group("Streaks", badges: streaks)
                    group("Events", badges: events)
                }
                .padding(.bottom, 80)
            }
            .navigationTitle("Badges")
        }
    }

    private var summary: some View {
        let unlocked = (achievements + streaks + events).filter { $0.unlocked }.count
        let total = achievements.count + streaks.count + events.count
        return VStack(spacing: 6) {
            Text("\(unlocked) / \(total)")
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundStyle(.tint)
            Text("Badges unlocked")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(.tint.opacity(0.08), in: .rect(corners: .concentric(minimum: .fixed(24))))
        .padding(.horizontal)
    }

    private func group(_ title: String, badges: [Badge]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)

            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(badges) { badge in
                    VStack(spacing: 10) {
                        Image(systemName: badge.icon)
                            .font(.system(size: 34))
                            .foregroundStyle(badge.unlocked ? AnyShapeStyle(.tint) : AnyShapeStyle(.tertiary))
                            .frame(height: 56)
                        Text(badge.title)
                            .font(.subheadline.weight(.medium))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(badge.unlocked ? .primary : .secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        (badge.unlocked ? Color.accentColor.opacity(0.10) : Color.gray.opacity(0.10)),
                        in: .rect(corners: .concentric(minimum: .fixed(20)))
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Impact

struct ImpactTab: View {
    private struct Stat: Identifiable {
        let id = UUID()
        let label: String
        let value: String
        let icon: String
        let delta: String
    }

    private struct Milestone: Identifiable {
        let id = UUID()
        let title: String
        let date: String
        let icon: String
    }

    private let stats: [Stat] = [
        .init(label: "Sessions", value: "248", icon: "calendar", delta: "+12 this week"),
        .init(label: "Hours saved", value: "36.5", icon: "clock.fill", delta: "+2.4 this week"),
        .init(label: "Trees planted", value: "12", icon: "leaf.fill", delta: "+1 this month"),
        .init(label: "CO₂ offset", value: "184 kg", icon: "wind", delta: "+9 kg this month"),
        .init(label: "Water saved", value: "1.2k L", icon: "drop.fill", delta: "+80 L this week"),
        .init(label: "Energy saved", value: "92 kWh", icon: "bolt.fill", delta: "+5 kWh this week"),
    ]

    private let weekly: [(String, Double)] = [
        ("Mon", 0.45), ("Tue", 0.70), ("Wed", 0.55),
        ("Thu", 0.85), ("Fri", 0.95), ("Sat", 0.60), ("Sun", 0.40),
    ]

    private let milestones: [Milestone] = [
        .init(title: "Reached 200 sessions", date: "2 days ago", icon: "flag.checkered"),
        .init(title: "Planted your 10th tree", date: "1 week ago", icon: "leaf.circle.fill"),
        .init(title: "Saved 30 hours total", date: "3 weeks ago", icon: "clock.badge.checkmark"),
        .init(title: "First 100 kg of CO₂ offset", date: "1 month ago", icon: "wind"),
        .init(title: "30-day streak", date: "1 month ago", icon: "flame.fill"),
        .init(title: "Joined the community", date: "Jan 2026", icon: "person.2.fill"),
    ]

    private let contributors: [(String, String)] = [
        ("Alex Chen", "32 sessions"),
        ("Maya Patel", "28 sessions"),
        ("Tom Hardy", "24 sessions"),
        ("Sofia López", "21 sessions"),
        ("Yuki Tanaka", "18 sessions"),
    ]

    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 14)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    statGrid
                    weeklyChart
                    milestonesList
                    contributorsList
                }
                .padding(.bottom, 80)
            }
            .navigationTitle("Impact")
        }
    }

    private var statGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This year")
                .font(.headline)
                .padding(.horizontal)
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(stats) { stat in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: stat.icon)
                                .font(.title3)
                                .foregroundStyle(.tint)
                                .frame(width: 36, height: 36)
                                .background(.tint.opacity(0.15), in: .circle)
                            Spacer()
                        }
                        Text(stat.value)
                            .font(.title2.weight(.semibold))
                        Text(stat.label)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(stat.delta)
                            .font(.caption)
                            .foregroundStyle(.tint)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(.tint.opacity(0.08), in: .rect(corners: .concentric(minimum: .fixed(20))))
                }
            }
            .padding(.horizontal)
        }
    }

    private var weeklyChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This week")
                .font(.headline)
                .padding(.horizontal)

            HStack(alignment: .bottom, spacing: 12) {
                ForEach(Array(weekly.enumerated()), id: \.offset) { _, day in
                    VStack(spacing: 8) {
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.tint.opacity(0.15))
                                .frame(height: 140)
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.tint)
                                .frame(height: 140 * day.1)
                        }
                        Text(day.0)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(16)
            .background(.tint.opacity(0.06), in: .rect(corners: .concentric(minimum: .fixed(20))))
            .padding(.horizontal)
        }
    }

    private var milestonesList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Milestones")
                .font(.headline)
                .padding(.horizontal)
            VStack(spacing: 8) {
                ForEach(milestones) { m in
                    HStack(spacing: 14) {
                        Image(systemName: m.icon)
                            .font(.title3)
                            .foregroundStyle(.tint)
                            .frame(width: 40, height: 40)
                            .background(.tint.opacity(0.15), in: .circle)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(m.title)
                                .font(.subheadline.weight(.medium))
                            Text(m.date)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding(14)
                    .background(.tint.opacity(0.08), in: .rect(corners: .concentric(minimum: .fixed(16))))
                }
            }
            .padding(.horizontal)
        }
    }

    private var contributorsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top contributors")
                .font(.headline)
                .padding(.horizontal)
            VStack(spacing: 8) {
                ForEach(Array(contributors.enumerated()), id: \.offset) { i, c in
                    HStack(spacing: 14) {
                        Text("\(i + 1)")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.tint)
                            .frame(width: 28, height: 28)
                            .background(.tint.opacity(0.15), in: .circle)
                        Text(c.0)
                            .font(.subheadline.weight(.medium))
                        Spacer()
                        Text(c.1)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(14)
                    .background(.tint.opacity(0.08), in: .rect(corners: .concentric(minimum: .fixed(16))))
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    TabBarDemoView()
}
