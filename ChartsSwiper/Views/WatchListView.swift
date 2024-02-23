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
        List {
            Section(header:
                HStack{
                    Text("Stock")
                        .fontWeight(.bold)
                        .frame(width: 100, alignment: .leading)
                    Text("Ticker")
                        .fontWeight(.bold)
                        .frame(width: 100, alignment: .leading)
                    Text("Price")
                        .fontWeight(.bold)
                        .frame(width: 70)
                }
            ) {
                ForEach(viewModel.watchlistStocksWithPrices, id: \.symbol) { stock in
                    HStack {
                        Text(stock.displayName)
                            .frame(width: 100, alignment: .leading)
                        Text(stock.symbol)
                            .frame(width: 80, alignment: .leading)
                        HStack{
                            Text("USD")
                                .font(.system(size: 14))
                            Text(String(format: "%.2f", stock.regularMarketPrice ?? 0))
                                .frame(alignment: .trailing)
                                .frame(width: 70)
                                .foregroundColor(.green)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchWatchlistStocksWithPrices()
        }
        .navigationTitle("Watchlist")
    }

}
