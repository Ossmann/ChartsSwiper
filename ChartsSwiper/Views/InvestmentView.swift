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
    @State private var showDisclaimer = false     // State to keep track of whether the disclaimer should be shown

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
                
                Spacer()

                // Use a DisclosureGroup for a better UX for Disclaimer
                DisclosureGroup("Show Disclaimer", isExpanded: $showDisclaimer) {
                    Text("The information listed here does not constitute investment advice. No guarantee that the data is correct or up to date. Data Source Yahoo Finance RapidAPI.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(.slide)
                }
                .accentColor(.gray) // Customize the color to match your app's theme
                .animation(.easeInOut, value: showDisclaimer)
                .font(.footnote)
                .padding()

                
                            
                            

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
