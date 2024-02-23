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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    loadDataInBackground()
                }
                // Pass the managed object context to the ContentView
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    //Function to load my CSV stock data into the CoreData (defined in DataLoader)
    private func loadDataInBackground() {
        DispatchQueue.global(qos: .background).async {
            let backgroundContext = self.persistenceController.container.newBackgroundContext()
            DataLoader.loadCSVAndInsertIntoCoreData(fileName: "top_2000_stocks_normalized.csv", context: backgroundContext)
        }
    }
}

