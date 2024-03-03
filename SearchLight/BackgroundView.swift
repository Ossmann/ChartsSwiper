//
//  BackgroundView.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 24/2/2024.
//

import SwiftUI

struct BackgroundView<Content: View>: View {
    var content: () -> Content

    var body: some View {
        ZStack {
            // Your gradient background
            LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.7), Color.blue.opacity(0.4), Color.white.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            content() // Call as a closure
        }
    }
}

