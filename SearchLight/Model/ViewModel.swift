import SwiftUI
import Foundation
import CoreData
import Combine

struct YahooFinanceResponse: Codable {
    struct Meta: Codable {
        let regularMarketPrice: Double
    }
    let meta: Meta
    let body: [String: HistoryItem]
    
    struct HistoryItem: Codable {
        let date: String
        let close: Double
        let volume: Int
    }
}

struct APIStock: Identifiable, Codable {
    let id = UUID()
    let symbol: String
    let regularMarketPrice: Double
    let history: [StockHistory] // Array to hold all the close prices
}

struct StockHistory: Codable {
    let timestamp: Int
    let date: String
//    let open: Double
//    let high: Double
//    let low: Double
    let close: Double
    let volume: Int
}

// The main stock entity where every data we need is combined (Live API, matchScore, Indicators from Yahoo Finance CSV, historical data)
struct DetailStock: Identifiable, Codable {
    let id = UUID()
    let symbol: String
    let regularMarketPrice: Double
    let name: String
    let matchScore: Float
    let history: [StockHistory] // Array to hold all the close prices
}


// View model that loads and stores the stocks (DummyStocks)
class StockCoordinator: ObservableObject {
    @Published var stocks: [DetailStock] = []

    init() {
        loadStockJSON()
    }

    func loadStockJSON() {
        // Locate the JSON file in the app bundle
        guard let path = Bundle.main.path(forResource: "dummyStocks", ofType: "json") else {
            print("File not found.")
            return
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            
            // Decode the JSON data directly into an array of DetailStock
            let decoder = JSONDecoder()
            let decodedStocks = try decoder.decode([DetailStock].self, from: data)

            // Assign the decoded stocks array to the `stocks` property
            self.stocks = decodedStocks
            print("Successfully loaded stocks: \(self.stocks)")
        } catch {
            print("Failed to load or decode JSON: \(error)")
        }
    }
}

/// STRUCTS FOR WATCHLIST

class WatchlistManager: ObservableObject {
    @Published var watchlist: [DetailStock] = []

    private let watchlistKey = "watchlist"

    init() {
        loadWatchlist()
    }

    func addStock(_ stock: DetailStock) {
        if !watchlist.contains(where: { $0.id == stock.id }) {
            watchlist.append(stock)
            saveWatchlist()
        }
    }

    func removeStock(_ stock: DetailStock) {
        watchlist.removeAll { $0.id == stock.id }
        saveWatchlist()
    }

    private func loadWatchlist() {
        if let data = UserDefaults.standard.data(forKey: watchlistKey) {
            if let decoded = try? JSONDecoder().decode([DetailStock].self, from: data) {
                self.watchlist = decoded
            }
        }
    }

    private func saveWatchlist() {
        if let encoded = try? JSONEncoder().encode(watchlist) {
            UserDefaults.standard.set(encoded, forKey: watchlistKey)
        }
    }
}
