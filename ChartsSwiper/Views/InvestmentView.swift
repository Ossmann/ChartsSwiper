//
//  InvestmentView.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 5/11/2023.
//


import SwiftUI
import CoreData


struct InvestmentView: View {
    @StateObject private var viewModel = StockCoordinator()
    @State private var animate = false  // State variable to control animation

    var body: some View {
        NavigationView { // Start of the NavigationView
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
                    ForEach(viewModel.detailStocks) { stock in
                        CardView(stock: stock)
                    }
                }

                Spacer() // Pushes everything to the top

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
                .padding(.bottom) // Add some padding at the bottom

            } // VStack ends here
            .navigationTitle("Ideas for You") // Sets the navigation bar title
            .navigationBarTitleDisplayMode(.inline) // Sets the title display mode
            .onAppear {
                Task {
                    await viewModel.displayTopStocks()
                }
            }
        } // End of the NavigationView
    }
}

