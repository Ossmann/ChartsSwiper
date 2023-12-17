//
//  WatchListView.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 5/11/2023.
//

import SwiftUI

struct WatchListView: View {
    @EnvironmentObject var watchlistViewModel: WatchlistViewModel
    
    var body: some View {
        // Display the stocks in the watchlist
        List(watchlistViewModel.watchlist) { stock in
            Text(stock.symbol)
            Text("\(stock.regularMarketPrice)")
        }
    }
}


