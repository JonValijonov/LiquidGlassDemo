//
//  ContentView.swift
//  LiquidGlassDemo
//
//  Created by Jon Valijonov on 03/06/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("ConcentricRectangle") {
                    ConcentricRectangleDemoView()
                }
                NavigationLink("TabBar SwiftUI") {
                    TabBarDemoView()
                }
                NavigationLink("TabBar UIKit") {
                    UIKitTabBarDemoView()
                        .ignoresSafeArea()
                }
                NavigationLink("Segmented control") {
                    SegmentedControlDemoView()
                }
                NavigationLink("Search Bar") {
                    SearchBarDemoView()
                }
            }
            .navigationTitle("Liquid Glass Demo")
        }
    }
}

#Preview {
    ContentView()
}
