import UIKit

struct YahooFinanceResponse: Codable {
    struct MetaData: Codable {
        let symbol: String
        let regularMarketPrice: Double
    }
            
    struct Item: Codable {
        let date: String
        let date_utc: Int
        let open: Double
        let high: Double
        let low: Double
        let close: Double
        let volume: Int
    }
    
    let meta: MetaData
    let body: [String: Item]

    enum CodingKeys: String, CodingKey {
        case meta
        case body
    }
}

struct Stock: Identifiable, Codable {
    let id = UUID()
    let symbol: String
    let regularMarketPrice: Double
    let history: [StockHistory] // Array to hold all the close prices
}

struct StockHistory: Codable {
    let timestamp: Int
    let date: String
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Int
}

// View Model
class StockViewModel: ObservableObject {
    @Published var stocks: [Stock] = []

    func fetchData() {
        print("Console Check 1")
        // Replace with your actual API key
        let apiKey = "c1dad428bbmsh5e5394b0b725461p153502jsn65a9f852101b"
        
        // List of stock symbols
        let largeCaps = [
            "AAPL"
        ]
        
        // Create a URLSession for making API requests
        let session = URLSession.shared
        
        print("Console Check 2")
        // Loop through each stock symbol and fetch data
        for symbol in largeCaps {
            // Define the API URL for the current stock symbol
            let urlString = "https://yahoo-finance15.p.rapidapi.com/api/v1/markets/stock/history?symbol=\(symbol)&interval=1d&diffandsplits=false"
            
            print("Console Check 3")
            // Create a URL object
            if let url = URL(string: urlString) {
                // Create a URLRequest with headers
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue(apiKey, forHTTPHeaderField: "X-RapidAPI-Key")
                request.setValue("yahoo-finance15.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
                
                print("Console Check 4")
                // Create a URLSession task to fetch the data
                session.dataTask(with: request) { data, response, error in

                    
                    print("Console Check 5")
                    if let data = data {
                        do {
                            // Parse the JSON data
                            let decoder = JSONDecoder()
                            var stockHistory: [StockHistory] = []

                            // Decode the JSON as a dictionary with timestamps as keys
                            let responseDict = try decoder.decode(YahooFinanceResponse.self, from: data)
                            
                            // Declare regularMarketPrice here
                            let regularMarketPrice = responseDict.meta.regularMarketPrice
                            
                            // Now, financeResponse.body is a dictionary where the key is a string (UNIX timestamp)
                            for (timestampString, item) in responseDict.body {
                                if let timestamp = Int(timestampString) {
                                    
                                    print(item.close)
                                    print("Test Console DATA")
                                    
                                    // Append StockHistory object
                                    stockHistory.append(StockHistory(
                                        timestamp: timestamp,
                                        date: item.date,
                                        open: item.open,
                                        high: item.high,
                                        low: item.low,
                                        close: item.close,
                                        volume: item.volume
                                    ))
                                }
                            }
                            
                            // You can update your UI here with the stock history
                            DispatchQueue.main.async {
                                // Update UI elements
                                self.stocks.append(Stock(symbol: symbol, regularMarketPrice: regularMarketPrice, history: stockHistory))
                            }
                        } catch {
                            print(error)
                        }
                    }
                }.resume()

            }
        }
    }
}
