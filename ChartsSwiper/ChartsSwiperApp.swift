//
//  ChartsSwiperApp.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 4/11/2023.
//

import SwiftUI

@main
struct ChartsSwiperApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var watchlistViewModel = WatchlistViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                // Pass the managed object context to the ContentView
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(watchlistViewModel)

        }
    }
}

