//
//  ChartsSwiperApp.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 4/11/2023.
//

import SwiftUI

@main
struct SearchLightApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var watchlistManager = WatchlistManager()
    @StateObject private var stockCoordinator = StockCoordinator() // Create StockCoordinator as a StateObject

    var body: some Scene {
        WindowGroup {
            BackgroundView {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(watchlistManager)
                    .environmentObject(stockCoordinator) // Pass StockCoordinator as an environment object
            }
        }
    }
}


