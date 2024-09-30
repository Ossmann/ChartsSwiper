//
//  StockDetailView.swift
//  SearchLight
//
//  Created by Jakob Ossmann on 30/9/2024.
//

import SwiftUI
import Charts

// Define a StockDetailView to show more information about the stock
struct StockDetailView: View {
    let stock: DetailStock
    
    // Computed property to extract every 10th date from the stock history
    var displayedDates: [String] {
        stock.history.enumerated().compactMap { index, history in
            index % 10 == 0 ? history.date : nil
        }
    }

    var body: some View {
    
        VStack {
            //Stock name with a maximum of 16 characters
            Text(String(stock.name))
                .font(.largeTitle)
                .bold()
                .padding()
                .frame(maxWidth: .infinity) // Ensures it takes up the full width
                .multilineTextAlignment(.center) // Center the text within the frame
            Text("Ticker: \(stock.symbol)")
            Text("Price: $" + String(format: "%.2f", stock.regularMarketPrice))
            
            // Create the Chart
            Chart {
                ForEach(stock.history, id: \.date) { history in
                    AreaMark(
                        x: .value("Date", history.date),
                        y: .value("Close", Double(history.close) ?? 0)
                    )
                    .interpolationMethod(.catmullRom) // Optional: Smooths the line
                }
            }
            // Display dates on X-axis
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    if let date = value.as(String.self), displayedDates.contains(date) {
                        AxisValueLabel()
                    }
                }
            }
            
            // Display $ signs on Y-axis
            .chartYAxis {
                AxisMarks(preset: .extended, position: .leading, values: .automatic) {
                    AxisGridLine()
                    AxisValueLabel(format: .currency(code: "USD"))
                }
            }
            .frame(width: 260, height: 200) // Adjust chart size
        }
        .padding()
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
