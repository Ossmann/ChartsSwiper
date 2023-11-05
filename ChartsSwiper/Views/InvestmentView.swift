
import SwiftUI
import CoreData
import Lottie


struct InvestmentView: View {
    @StateObject private var viewModel = StockViewModel() // Instance of StockViewModel
    @State private var animate = false  // State variable to control animation


    var body: some View {
            VStack {
                HStack {
                    Image(systemName: "square.stack")
                    // Animation to promote swiping
                    Image(systemName: "hand.tap")
                        .font(.largeTitle)
                        .offset(x: animate ? 10 : -10) // Change the offset here
                        .animation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: animate)
                        .onAppear {
                            animate = true
                        }
                }
                Text("Swipe left to dismiss, or right to add stocks to watchlist.")

                //Stack of Cards
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
