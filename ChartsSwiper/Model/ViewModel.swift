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
    let close: String
    let volume: String
}

// View Model
class StockViewModel: ObservableObject {
    @Published var stocks: [Stock] = []

    func fetchData() {
        // Replace with your actual API key
        let apiKey = "I4PVPPK8S4HRN8RA"
        
        // Define the API URL
        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=IBM&apikey=\(apiKey)"
        
        // Create a URL object
        if let url = URL(string: urlString) {
            // Create a URLSession task to fetch the data
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        // Parse the JSON data
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(AlphaVantageResponse.self, from: data)
                        
                        // Get the latest day's close price
                        if let latestDay = response.timeSeries.keys.sorted().last,
                           let timeSeriesData = response.timeSeries[latestDay] {
                            print("Latest close price on \(latestDay): \(timeSeriesData.close)")
                            
                            // You can update your UI here with the latest close price
                            DispatchQueue.main.async {
                                // Update UI elements
                                let stock = Stock(symbol: response.metaData.symbol, close: timeSeriesData.close, volume: timeSeriesData.volume)
                                self.stocks.append(stock)
                            }
                        }
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                    }
                } else if let error = error {
                    print("Error fetching data: \(error.localizedDescription)")
                }
            }.resume() // Don't forget to call resume on the task
        }
    }
}
