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
                NavigationLink("TabBar") {
                    TabBarDemoView()
                }
                NavigationLink("TabBar UIKit") {
                    UIKitTabBarDemoView()
                        .ignoresSafeArea()
                }
                NavigationLink("Segmented control") {
                    SegmentedControlDemoView()
                }
            }
            .navigationTitle("Liquid Glass Demo")
        }
    }
}

#Preview {
    ContentView()
}
