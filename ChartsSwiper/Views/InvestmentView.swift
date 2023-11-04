
import SwiftUI
import CoreData

struct InvestmentView: View {
    @StateObject private var viewModel = StockViewModel() // Instance of StockViewModel

    var body: some View {
            VStack {
                ZStack {
                    ForEach(viewModel.stocks) { stock in
                        CardView(stock: stock)
                    }
                }
            }// Fetch data when the view appears
            .onAppear{
                viewModel.fetchData()
            }
        
        Text("Demo Data: AlphaVantage.co, No commercial use")
            .font(.footnote) // This makes the font smaller

        }
    
}

