//
//  WatchListView.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 5/11/2023.
//

import SwiftUI
import CoreData

struct WatchListView: View {
    // Access the managed object context from the environment
    @Environment(\.managedObjectContext) private var viewContext

    // Prepare a fetch request to fetch WatchListStock entities
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WatchListStock.symbol, ascending: true)],
        animation: .default)
    private var watchlist: FetchedResults<WatchListStock>

    var body: some View {
        NavigationView {
            List {
                // Iterate over the fetched results
                ForEach(watchlist, id: \.self) { stock in
                    // Display the properties of WatchListStock, for example, symbol
                    Text(stock.symbol ?? "Unknown Symbol")
                }
                .onDelete(perform: deleteStocks)
            }
            .navigationBarTitle(Text("Your Watchlist"))
        }
    }

    private func deleteStocks(offsets: IndexSet) {
        withAnimation {
            offsets.map { watchlist[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Handle the error
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


