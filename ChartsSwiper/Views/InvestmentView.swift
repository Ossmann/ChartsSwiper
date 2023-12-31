//
//  InvestmentView.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 5/11/2023.
//


import SwiftUI
import CoreData


struct InvestmentView: View {
    @StateObject private var viewModel = APIStockViewModel() // Instance of StockViewModel
    @State private var animate = false  // State variable to control animation


    var body: some View {
        
            VStack {
                HStack {
                    Image(systemName: "square.stack")
                    // Animation to promote swiping
                    Image(systemName: "hand.tap")
                        .font(.largeTitle)
                        .offset(x: animate ? 10 : -10) // Change the offset here
                        .animation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animate)
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
                print("Test Console Investment VIew")
                viewModel.fetchData()
            }
        
        Text("Demo Data: AlphaVantage.co, No commercial use")
            .font(.footnote) // This makes the font smaller
        
        
        // Navigation link to Watchlist
        NavigationLink(destination: WatchListView()) {
                        Text("To My Watchlist")
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }

        }
    
}
