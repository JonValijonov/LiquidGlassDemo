//
//  UIKitSearchBarDemoView.swift
//  LiquidGlassDemo
//
//  Created by Jon Valijonov on 11/06/2026.
//

import SwiftUI
import UIKit
import MapKit

/// The same "Search Location" screen as `SearchBarDemoView`, but built entirely
/// in UIKit and wrapped for SwiftUI. Reuses its own `UINavigationController` so
/// the accent-tinted bar, title and back button are UIKit-native — the parent
/// SwiftUI nav bar is hidden by the caller.
struct UIKitSearchBarDemoView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UINavigationController {
        let searchVC = SearchLocationViewController()
        searchVC.onBack = { dismiss() }
        let nav = UINavigationController(rootViewController: searchVC)
        nav.navigationBar.barStyle = .black // light status-bar content over the red bar
        return nav
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

final class SearchLocationViewController: UIViewController {
    /// Called when the UIKit back button is tapped — pops the SwiftUI stack.
    var onBack: (() -> Void)?

    private let accent = UIColor(red: 0.93, green: 0.10, blue: 0.18, alpha: 1)
    private let pinCoordinate = CLLocationCoordinate2D(latitude: 39.5501, longitude: -105.7821)

    private let mapView = MKMapView()
    private let searchField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureNavigationBar()
        configureBottomStack()
    }

    // MARK: - Map

    private func configureMap() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.setRegion(
            MKCoordinateRegion(
                center: pinCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 18, longitudeDelta: 18)
            ),
            animated: false
        )

        let annotation = MKPointAnnotation()
        annotation.coordinate = pinCoordinate
        mapView.addAnnotation(annotation)

        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    // MARK: - Navigation bar

    private func configureNavigationBar() {
        navigationItem.title = "Search Location"
        navigationItem.largeTitleDisplayMode = .never

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = accent
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white

        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(didTapBack)
        )
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func didTapBack() {
        onBack?()
    }

    // MARK: - Result card + search bar

    private func configureBottomStack() {
        let stack = UIStackView(arrangedSubviews: [makeResultCard(), makeSearchBar()])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        // Pin to the keyboard layout guide so the stack rises above the keyboard
        // when it appears, and rests at the bottom safe area when it's dismissed
        // — matching SwiftUI's `.safeAreaInset` keyboard avoidance.
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -8),
        ])
    }

    /// "Houston, TX / United States" card on a Liquid Glass background.
    private func makeResultCard() -> UIView {
        let card = UIVisualEffectView(effect: UIGlassEffect())
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.cornerRadius = 14
        card.layer.cornerCurve = .continuous
        card.clipsToBounds = true

        let title = UILabel()
        title.text = "Houston, TX"
        title.font = .systemFont(ofSize: 17, weight: .semibold)
        title.textColor = .label

        let subtitle = UILabel()
        subtitle.text = "United States"
        subtitle.font = .systemFont(ofSize: 14)
        subtitle.textColor = .secondaryLabel

        let labels = UIStackView(arrangedSubviews: [title, subtitle])
        labels.axis = .vertical
        labels.spacing = 4

        let chevron = UIImageView(
            image: UIImage(
                systemName: "chevron.right",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
            )
        )
        chevron.tintColor = accent
        chevron.setContentHuggingPriority(.required, for: .horizontal)

        let row = UIStackView(arrangedSubviews: [labels, UIView(), chevron])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 12
        row.translatesAutoresizingMaskIntoConstraints = false
        card.contentView.addSubview(row)

        NSLayoutConstraint.activate([
            row.leadingAnchor.constraint(equalTo: card.contentView.leadingAnchor, constant: 18),
            row.trailingAnchor.constraint(equalTo: card.contentView.trailingAnchor, constant: -18),
            row.topAnchor.constraint(equalTo: card.contentView.topAnchor, constant: 16),
            row.bottomAnchor.constraint(equalTo: card.contentView.bottomAnchor, constant: -16),
        ])
        return card
    }

    /// White capsule container sitting behind the field, so it reads as solid
    /// white instead of Liquid Glass — same trick as the SwiftUI version.
    private func makeSearchBar() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        container.layer.cornerRadius = 25
        container.layer.cornerCurve = .continuous
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.12
        container.layer.shadowRadius = 8
        container.layer.shadowOffset = CGSize(width: 0, height: 2)

        let icon = UIImageView(
            image: UIImage(
                systemName: "magnifyingglass",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
            )
        )
        icon.tintColor = .secondaryLabel
        icon.setContentHuggingPriority(.required, for: .horizontal)

        searchField.placeholder = "Search"
        searchField.text = "Houston"
        searchField.textColor = .black
        searchField.borderStyle = .none
        searchField.clearButtonMode = .whileEditing
        searchField.returnKeyType = .search

        let row = UIStackView(arrangedSubviews: [icon, searchField])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 8
        row.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(row)

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 50),
            row.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            row.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            row.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
        return container
    }
}

// MARK: - MKMapViewDelegate

extension SearchLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            ?? MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        let config = UIImage.SymbolConfiguration(paletteColors: [.white, accent])
            .applying(UIImage.SymbolConfiguration(pointSize: 36))
        view.image = UIImage(systemName: "mappin.circle.fill", withConfiguration: config)
        view.annotation = annotation
        return view
    }
}

#Preview {
    UIKitSearchBarDemoView()
        .ignoresSafeArea()
}
