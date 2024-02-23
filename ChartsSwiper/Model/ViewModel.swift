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
    let matchScore: Float
    let peRatio: Float
    let history: [StockHistory] // Array to hold all the close prices
}

// Update Core Data with PE Ratios and MatchScores
class MatchService: ObservableObject {
    func updateMatchScores(peRatioPreference: Float) {
        let viewContext = PersistenceController.shared.container.viewContext
        
        let fetchRequest: NSFetchRequest<DBStock> = DBStock.fetchRequest()
        
        do {
            let stocks = try viewContext.fetch(fetchRequest)
            
            print("test match calculation")
            
            for stock in stocks {
                    stock.matchScore = peRatioPreference * (stock.peRatio ?? 0)
                
////                if stock.symbol == "AAPL" || stock.symbol == "GM" {
//                    print("Match Score for \(String(describing: stock.symbol)):", stock.matchScore)
//                }
 
            }
            
            // Save the context after updating match scores
            try viewContext.save()
            
        } catch {
            print("Error fetching stocks: \(error)")
        }
    }
}

//Filter the top 20 stocks based on matchScore
class StockFilterService {
    func getTopStocks() async throws -> [DBStock] {
        let viewContext = PersistenceController.shared.container.viewContext
        
        let fetchRequest: NSFetchRequest<DBStock> = DBStock.fetchRequest()
        // Sort by matchScore in descending order to get the highest scores first
        let sortDescriptor = NSSortDescriptor(key: #keyPath(DBStock.matchScore), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Set the fetch limit to 20 to get only the top 20 stocks
        fetchRequest.fetchLimit = 4
        
        do {
            // Fetch the top 20 stocks
            let topTwentyStocks = try viewContext.fetch(fetchRequest)
            print("test Filtering")
            print(topTwentyStocks)
            return topTwentyStocks
        } catch {
            print("Error fetching stocks: \(error)")
            throw error
        }
    }
}

//Fetch Price and Historical Prices for 20 selected stocks
class StockAPIService {
    // Fetch data from the API
    func fetchDetailsForStocks(stocks: [DBStock]) async throws -> [DetailStock] {
        print("Fetching API key...") // Print statement 1
        guard let apiKey = fetchAPIKey() else {
            throw NSError(domain: "StockAPIService", code: 0, userInfo: [NSLocalizedDescriptionKey: "API key is missing"])
        }
        print("API key fetched successfully.") // Print statement 2
        
        var details: [DetailStock] = []
        
        for stock in stocks {
//            print("Fetching details for stock: \(stock.symbol ?? "UNKNOWN")") // Print statement 3
            let detailStock = try await fetchDetailForStock(stock: stock, apiKey: apiKey)
            details.append(detailStock)
//            print("Details fetched for stock: \(stock.symbol ?? "UNKNOWN")") // Print statement 4
        }
        
        return details
    }
    //Get the API Key from the Config File
    private func fetchAPIKey() -> String? {
        print("Accessing API key from Config file...") // Print statement 5
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            print("Failed to access API key from Config file.") // Print statement 6
            return nil
        }
        return dict["APIKey"] as? String
    }
    
    //Get the price from a stock from the API
    private func fetchDetailForStock(stock: DBStock, apiKey: String) async throws -> DetailStock {
//        print("Fetching details for stock: \(stock.symbol)")
        let urlSymbol = stock.symbol ?? "AAPL"
        let urlString = "https://yahoo-finance15.p.rapidapi.com/api/v1/markets/stock/history?symbol=\(urlSymbol)&interval=1d&diffandsplits=false"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "StockAPIService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue("yahoo-finance15.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        
//        print("Requesting stock details from API for symbol: \(stock.symbol ?? "UNKNOWN")") // Print statement A
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
//            print("Received data from API for symbol: \(stock.symbol ?? "UNKNOWN")") // Print statement B
            
            do {
                let responseDict = try JSONDecoder().decode(YahooFinanceResponse.self, from: data)
//                print("Decoded response successfully for symbol: \(stock.symbol ?? "UNKNOWN")") // Print statement C
                
                let regularMarketPrice = responseDict.meta.regularMarketPrice
                var stockHistory: [StockHistory] = []
                
                let timestampItems = Array(responseDict.body.keys.sorted())
                let lastTimestamps = Array(timestampItems.suffix(30)) // Adjust as necessary
                
                for timestampString in lastTimestamps {
                    if let item = responseDict.body[timestampString], let timestamp = Int(timestampString) {
                        stockHistory.append(StockHistory(
                            timestamp: timestamp,
                            date: item.date,
                            close: item.close,
                            volume: item.volume
                        ))
                    }
                }
//                print("Processed historical data for symbol: \(stock.symbol ?? "UNKNOWN")") // Print statement D
                
                return DetailStock(
                    symbol: stock.symbol ?? "DEFAULT",
                    regularMarketPrice: regularMarketPrice,
                    matchScore: stock.matchScore,
                    peRatio: stock.peRatio,
                    history: stockHistory
                )
            } catch {
                print("Failed to decode response for symbol: \(stock.symbol ?? "UNKNOWN"). Error: \(error.localizedDescription)") // Print statement E
                throw error
            }
        } catch {
            print("Failed to fetch data from API for symbol: \(stock.symbol ?? "UNKNOWN"). Error: \(error.localizedDescription)") // Print statement F
            throw error
        }
    }
}



//Bring together API Stocks and Stocks from CoreData
class StockCoordinator: ObservableObject {
    @Published var detailStocks: [DetailStock] = []
    private let filterService = StockFilterService()
    private let apiService = StockAPIService()

    // This method can be called from a SwiftUI view directly to load stocks
    func displayTopStocks() async {
        do {
            let topStocks = try await filterService.getTopStocks()
            detailStocks = try await apiService.fetchDetailsForStocks(stocks: topStocks)
        } catch {
            // Handle any errors, perhaps by setting an error message in a @Published property
        }
    }
}


// View Model to get the Preferences of the User and calculate matchScore
class MatchViewModel: ObservableObject {
    func updateMatchScores(peRatioPreference: Float) {
        let viewContext = PersistenceController.shared.container.viewContext
        
        let fetchRequest: NSFetchRequest<DBStock> = DBStock.fetchRequest()
        
        do {
            let stocks = try viewContext.fetch(fetchRequest)
            
            print("test match calculation")
            
            for stock in stocks {
                if stock.symbol == "AAPL" || stock.symbol == "GM" {
                    stock.matchScore = peRatioPreference * (stock.peRatio ?? 0)
                
                    print("Match Score for \(String(describing: stock.symbol)):", stock.matchScore)
                }
 
            }
            
            // Save the context after updating match scores
            try viewContext.save()
            
        } catch {
            print("Error fetching stocks: \(error)")
        }
    }
}


/// STRUCTS FOR WATCHLIST

// Define the response structure based on the actual JSON response from the API
struct YahooFinanceQuoteResponse: Codable {
    let body: [StockQuote]

    struct StockQuote: Codable {
        let regularMarketPrice: Double
        let displayName: String
        let symbol: String
        // Include other properties from the JSON as needed
    }
}


struct WatchListStock {
    let regularMarketPrice: Double?
    let displayName: String
    let symbol: String // Assuming this is a Double, adjust based on actual data type

    // Define an initializer that takes the symbol and regularMarketPrice as arguments
    init(symbol: String, regularMarketPrice: Double?, displayName: String) {
        self.symbol = symbol
        self.regularMarketPrice = regularMarketPrice
        self.displayName = displayName
    }
}


//Model for the Watchlist to add Stocks to WatchList
class WatchlistAdditionService: ObservableObject {
    
    //add stocks to the watchlist
    func addToWatchlist(cardStock: DetailStock) {
        let viewContext = PersistenceController.shared.container.viewContext
        
        let fetchRequest: NSFetchRequest<WatchListCoreStock> = WatchListCoreStock.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "symbol == %@", cardStock.symbol)
        
        do {
            let existingStocks = try viewContext.fetch(fetchRequest)
            
            // If the stock is not already in the watchlist, add it
            if existingStocks.isEmpty {
                let newWatchListStock = WatchListCoreStock(context: viewContext)
                newWatchListStock.symbol = cardStock.symbol
                // Set any other properties of WatchListCoreStock from DetailStock if necessary
                
                try viewContext.save()
                print("New stock added to Watchlist")
            } else {
                print("Stock is already in the watchlist")
            }
            
        } catch {
            print("Error fetching stocks or saving to context: \(error)")
        }
    }
}


//ViewModel of the WatchList that combines CoreData and API

class WatchlistViewModel: ObservableObject {
    @Published var watchlistStocksWithPrices: [WatchListStock] = []

    // Reference to PersistenceController (adjust according to your app's architecture)
    private let persistenceController = PersistenceController.shared

    init() {
        fetchWatchlistStocksWithPrices()
    }

    // Inside WatchlistViewModel class
    func fetchWatchlistStocksWithPrices() {
        print("Fetching watchlist stocks with prices")
        let symbols = getWatchListSymbols()
        if symbols.isEmpty {
            print("No symbols fetched from CoreData. Exiting fetch operation.")
            return
        }

        guard let apiKey = fetchAPIKey() else {
            print("API Key could not be found. Please ensure it's correctly set in the Config.plist file.")
            return
        }

        print("Fetched symbols: \(symbols)")
        print("Starting API call for stock prices")
        Task {
            do {
                let stockQuotes = try await apiPriceCall(watchListSymbols: symbols, apiKey: apiKey)
                // Convert each StockQuote to a WatchListStock
                let updatedStocks = stockQuotes.map { WatchListStock(symbol: $0.symbol, regularMarketPrice: $0.regularMarketPrice, displayName: $0.displayName) }
                
                print("Successfully fetched stock prices, updating ViewModel")
                DispatchQueue.main.async {
                    self.watchlistStocksWithPrices = updatedStocks
                    print("ViewModel updated with \(updatedStocks.count) stocks")
                }
            } catch {
                print("Error fetching stock prices: \(error)")
            }
        }
    }


    private func getWatchListSymbols() -> String {
        print("Fetching watchlist symbols from CoreData")
        let viewContext = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<WatchListCoreStock> = WatchListCoreStock.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "symbol", ascending: true)]

        do {
            let watchlistStocks = try viewContext.fetch(fetchRequest)
            let symbols = watchlistStocks.compactMap { $0.symbol }.joined(separator: ",")
            print("Successfully fetched symbols: \(symbols)")
            return symbols
        } catch {
            print("Failed to fetch watchlist stocks: \(error.localizedDescription)")
            return ""
        }
    }


    private func apiPriceCall(watchListSymbols: String, apiKey: String) async throws -> [YahooFinanceQuoteResponse.StockQuote] {
        guard let encodedSymbols = watchListSymbols.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://yahoo-finance15.p.rapidapi.com/api/v1/markets/stock/quotes?ticker=\(encodedSymbols)") else {
            throw NSError(domain: "StockAPIService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        //Set HEADERS for API CALL
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue("yahoo-finance15.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")

        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Log the response data as a string for debugging purposes
            if let responseString = String(data: data, encoding: .utf8) {
                print("Received string: \(responseString)")
            }
        
        let response = try JSONDecoder().decode(YahooFinanceQuoteResponse.self, from: data)

        return response.body // This will be an array of StockQuote objects
    }



    
    // Fetch API Key from the Config.plist file
    private func fetchAPIKey() -> String? {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            return nil
        }
        return dict["APIKey"] as? String
    }
    
    //delte stocks from Watchlist by swiping
    func deleteStocks(atOffsets offsets: IndexSet) {
        // First, remove the stocks from the in-memory array.
        let symbolsToDelete = offsets.map { watchlistStocksWithPrices[$0].symbol }
        watchlistStocksWithPrices.remove(atOffsets: offsets)

        // Prepare to delete from CoreData
        let viewContext = persistenceController.container.viewContext

        symbolsToDelete.forEach { symbol in
            let fetchRequest: NSFetchRequest<WatchListCoreStock> = WatchListCoreStock.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "symbol == %@", symbol)

            do {
                let results = try viewContext.fetch(fetchRequest)
                for object in results {
                    viewContext.delete(object)
                }
                try viewContext.save()
            } catch {
                // Handle the error appropriately
                print("Error deleting stock from CoreData: \(error)")
            }
        }
    }
}

