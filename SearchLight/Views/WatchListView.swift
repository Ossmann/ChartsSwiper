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
    var tutorialManager: TutorialManager

    var body: some View {
        NavigationView { // Wrap the List in a NavigationView
            BackgroundView {
                VStack {
                    List {
                        // Define the header for the list
                        Section(header:
                                    HStack {
                            Text("Stock")
                                .fontWeight(.bold)
                                .frame(width: 100)
                            Text("Ticker")
                                .fontWeight(.bold)
                                .frame(width: 100)
                            Text("Price")
                                .fontWeight(.bold)
                                .frame(width: 70)
                        }) {
                            // Iterate over the stocks in the watchlist
                            ForEach(watchlistManager.watchlist, id: \.symbol) { stock in
                                HStack {
                                    NavigationLink(destination: StockDetailView(stock: stock)) {
                                        HStack {
                                            Text(stock.name)
                                                .font(.system(size: 12))
                                                .frame(width: 100, alignment: .leading)
                                            Text(stock.symbol)
                                                .font(.system(size: 12))
                                                .frame(width: 100)
                                            HStack {
                                                Text(String(format: "$ %.2f", stock.regularMarketPrice))
                                                    .font(.system(size: 12))
                                                    .frame(width: 70)
                                                    .foregroundColor(.green)
                                            }
                                        }
                                    }
                                }
                                .listRowBackground(Color.white.opacity(0.5)) // Remove row background color
                            }
                            .onDelete(perform: removeStocks)
                        }
                    }
                    .padding()
                    .listStyle(PlainListStyle()) // Use plain list style to remove grouped background

                    // Button to Reset Preferences
                    Button(action: {
                        tutorialManager.resetPreferencesScreenShown()
                    }) {
                        Label("FIND NEW STOCKS", systemImage: "gear.badge.checkmark")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity) // Expand to take available space
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    .padding(.bottom)
                }
                .navigationTitle("Watchlist")
                .navigationBarTitleDisplayMode(.inline) // Sets the title display mode
            }
        }
    }

    // Define a separate remove function
    func removeStocks(at offsets: IndexSet) {
        offsets.forEach { index in
            let stock = watchlistManager.watchlist[index]
            watchlistManager.removeStock(stock)
        }
    }
}



///PREVIEW
struct WatchListView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock WatchlistManager and populate it with sample data
        let mockWatchlistManager = WatchlistManager()
        mockWatchlistManager.watchlist = [
            DetailStock(symbol: "AAPL", regularMarketPrice: 150.00, name: "Apple Inc.", matchScore: 0.95, history: [
                StockHistory(timestamp: 1625112000, date: "2021-07-01", close: 140.54, volume: 100_000)
            ]),
            DetailStock(symbol: "GOOGL", regularMarketPrice: 2800.00, name: "Alphabet Inc.", matchScore: 0.85, history: [
                StockHistory(timestamp: 1625198400, date: "2021-07-02", close: 2500.12, volume: 200_000)
            ]),
            DetailStock(symbol: "AMZN", regularMarketPrice: 3500.00, name: "Amazon.com Inc.", matchScore: 0.90, history: [
                StockHistory(timestamp: 1625284800, date: "2021-07-03", close: 3500.00, volume: 150_000)
            ])
        ]

        let mockTutorialManager = TutorialManager() // Assuming TutorialManager is defined elsewhere

        // Pass the mock data as environment objects
        return WatchListView(tutorialManager: mockTutorialManager)
            .environmentObject(mockWatchlistManager)
            .previewLayout(.sizeThatFits) // Adjust the layout to fit the preview window
    }
}
