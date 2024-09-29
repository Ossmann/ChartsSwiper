//
//  WatchListView.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 5/11/2023.
//

import SwiftUI
import CoreData

struct WatchListView: View {
    @EnvironmentObject var watchlistManager: WatchlistManager

    var body: some View {
        List {
            // Define the header for the list
            Section(header:
                        HStack {
                Text("Stock")
                    .fontWeight(.bold)
                    .frame(width: 100, alignment: .leading)
                Text("Ticker")
                    .fontWeight(.bold)
                    .frame(width: 100, alignment: .leading)
                Text("Price")
                    .fontWeight(.bold)
                    .frame(width: 70)
            }) {
                // Iterate over the stocks in the watchlist
                ForEach(watchlistManager.watchlist, id: \.symbol) { stock in
                    HStack {
                        Text(stock.name) // Using 'name' instead of 'displayName' if the property is not defined
                            .frame(width: 100, alignment: .leading)
                        Text(stock.symbol)
                            .frame(width: 80, alignment: .leading)
                        HStack {
                            Text("USD")
                                .font(.system(size: 14))
                            Text(String(format: "%.2f", stock.regularMarketPrice))
                                .frame(width: 70, alignment: .trailing)
                                .foregroundColor(.green)
                        }
                    }
                }
                // Add .onDelete only if the method is correctly defined
                .onDelete(perform: removeStocks)
            }
        }
        .navigationTitle("Watchlist")
        // Apply the gradient background if you have a custom view for it
        .background(BackgroundNavigationView())
    }

    // Define a separate remove function
    func removeStocks(at offsets: IndexSet) {
        offsets.forEach { index in
            let stock = watchlistManager.watchlist[index]
            watchlistManager.removeStock(stock)
        }
    }
}
