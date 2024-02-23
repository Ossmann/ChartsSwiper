//
//  WatchListView.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 5/11/2023.
//

import SwiftUI
import CoreData

struct WatchListView: View {
    @StateObject private var viewModel = WatchlistViewModel()

    var body: some View {
        List(viewModel.watchlistStocksWithPrices, id: \.symbol) { stock in
            HStack {
                Text(stock.symbol)
                    .fontWeight(.bold)
                
                Spacer() // This pushes the symbol and price to opposite sides of the HStack
                
                Text(String(format: "%.2f", stock.regularMarketPrice ?? ""))
                    .foregroundColor(.green)
            }
        }
        .onAppear {
            viewModel.fetchWatchlistStocksWithPrices()
        }
        .navigationTitle("Watchlist")
    }
}


