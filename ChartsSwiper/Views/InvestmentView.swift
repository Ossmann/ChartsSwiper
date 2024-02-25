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
    @State private var showHandTap = true // State to control the visibility of the hand tap image


    var body: some View {
        
            NavigationView { // Start of the NavigationView
                
                VStack {
                    
                    Spacer().frame(height: 20) // This Spacer pushes the button down

                    
                    Text("Swipe left to dismiss, or right to add stocks to your watchlist.")
                    
                    Spacer().frame(height: 40) // This Spacer
                    
                    //Stack of Cards
                    ZStack {
                        
                        ForEach(viewModel.detailStocks.indices, id: \.self) { index in
                            let stock = viewModel.detailStocks[index]
                            CardView(stock: stock)
                                .rotationEffect(.degrees(index == 0 ? 4 : 0)) // Rotate the first card
                                .shadow(radius: index == 0 ? 4 : 0)
                                // Apply a general animation if needed
                                .animation(Animation.easeInOut(duration: 1.2), value: animate)
                        }

                        if showHandTap { // Only show the image and text if showHandTap is true
                            VStack { // Use VStack to arrange the image and text vertically
                                Spacer().frame(height: 200) // Adjust spacer as needed to position the VStack
                                Image(systemName: "hand.tap")
                                    .font(.system(size: 80)) // Increase the size
                                    .opacity(0.5) // Make it partly transparent
                                    .offset(x: animate ? 10 : -10)
                                    .animation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animate)
                                Text("Creating your selection...") // This text will appear below the hand tap image
                            }
                            .onAppear {
                                animate = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 28) { // Adjusted to 30 seconds as per your code, though you mentioned 5 seconds in the first message
                                    // Hide the hand tap image and text after 12 seconds
                                    self.showHandTap = false
                                }
                            }
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
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black) // Make the button black
                            .cornerRadius(10)
                            .padding(.horizontal, 10)
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
                // Apply the gradient background to the entire VStack
                .background(BackgroundNavigationView())
            } // End of the NavigationView
        }
}
