//
//  StockDetailView.swift
//  SearchLight
//
//  Created by Jakob Ossmann on 30/9/2024.
//

import SwiftUI

// Define a StockDetailView to show more information about the stock
struct StockDetailView: View {
    let stock: DetailStock

    var body: some View {
        VStack(alignment: .leading) {
            Text(stock.name)
                .font(.largeTitle)
                .padding()
            Text("Symbol: \(stock.symbol)")
                .font(.title2)
                .padding(.horizontal)
            Text("Current Price: \(String(format: "%.2f", stock.regularMarketPrice)) USD")
                .font(.title3)
                .padding(.horizontal)

            Spacer()
        }
    }
}


//PREVIEW
struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample historical data for Apple Inc.
        let sampleHistory = [
            StockHistory(timestamp: 1695609600, date: "2023-09-25", close: 174.50, volume: 50000000),
            StockHistory(timestamp: 1695696000, date: "2023-09-26", close: 175.20, volume: 45000000),
            StockHistory(timestamp: 1695782400, date: "2023-09-27", close: 176.80, volume: 47000000)
        ]
        
        // Sample stock data for preview
        let sampleStock = DetailStock(
            symbol: "AAPL",
            regularMarketPrice: 175.50,
            name: "Apple Inc.",
            matchScore: 0.98,
            history: sampleHistory
        )
        
        // Preview the StockDetailView with sample data
        StockDetailView(stock: sampleStock)
            .previewLayout(.sizeThatFits) // Adjust the layout for better preview visualization
    }
}
