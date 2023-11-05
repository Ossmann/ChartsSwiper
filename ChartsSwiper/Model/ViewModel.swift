import UIKit

struct AlphaVantageResponse: Codable {
    struct MetaData: Codable {
        let symbol: String

        enum CodingKeys: String, CodingKey {
            case symbol = "2. Symbol"
        }
    }

    struct TimeSeries: Codable {
        let open: String
        let high: String
        let low: String
        let close: String
        let volume: String

        enum CodingKeys: String, CodingKey {
            case open = "1. open"
            case high = "2. high"
            case low = "3. low"
            case close = "4. close"
            case volume = "5. volume"
        }
    }

    let metaData: MetaData
    let timeSeries: [String: TimeSeries]

    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries = "Time Series (Daily)"
    }
}

struct Stock: Identifiable, Codable {
    let id = UUID()
    let symbol: String
    let history: [StockHistory] // Array to hold all the close prices
}

struct StockHistory: Codable {
    let date: String
    let close: String
}

// View Model
class StockViewModel: ObservableObject {
    @Published var stocks: [Stock] = []

    func fetchData() {
        // Replace with your actual API key
        let apiKey = "TXKSKIKJH52HMBB6"
        
        // List of stock symbols
        let largeCaps = [
            "AAPL", "MSFT", "AMZN", "GOOGL",
            "FB", "PG", "TSLA"
        ]
        
        // Create a URLSession for making API requests
        let session = URLSession.shared
        
        // Loop through each stock symbol and fetch data
        for symbol in largeCaps {
            // Define the API URL for the current stock symbol
            let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(symbol)&apikey=\(apiKey)"
            
            // Create a URL object
            if let url = URL(string: urlString) {
                // Create a URLSession task to fetch the data
                session.dataTask(with: url) { data, response, error in
                    if let data = data {
                        do {
                            // Parse the JSON data
                            let decoder = JSONDecoder()
                            let response = try decoder.decode(AlphaVantageResponse.self, from: data)
                            
                            // Iterate over all the dates in the response
                            var stockHistory: [StockHistory] = []
                            for (date, timeSeriesData) in response.timeSeries {
                                stockHistory.append(StockHistory(date: date, close: timeSeriesData.close))
                            }
                            
                            // Sort the history based on date
                            stockHistory.sort { $0.date > $1.date }
                            
                            // You can update your UI here with the stock history
                            DispatchQueue.main.async {
                                // Update UI elements
                                self.stocks.append(Stock(symbol: symbol, history: stockHistory))
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

