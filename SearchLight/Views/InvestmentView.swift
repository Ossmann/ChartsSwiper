//
//  InvestmentView.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 5/11/2023.
//


import SwiftUI
import CoreData


struct InvestmentView: View {
    @EnvironmentObject var viewModel: StockCoordinator
    var tutorialManager: TutorialManager
    @State private var animate = false  // State variable to control animation
    @State private var showDisclaimer = false     // State to keep track of whether the disclaimer should be shown
    @State private var showHandTap = true // State to control the visibility of the hand tap image


    var body: some View {
        
            NavigationView { // Start of the NavigationView
                
                VStack {
                    
                    Spacer().frame(height: 20) // This Spacer pushes the button down

                    HStack{
                        Image(systemName: "arrowshape.turn.up.left.circle.fill")
                            .foregroundColor(.red.opacity(0.8))
                        Text("Swipe left or right")
                        Image(systemName: "arrowshape.turn.up.right.circle.fill")
                            .foregroundColor(.green.opacity(0.8))
                    }
                    
                    Spacer().frame(height: 40) // This
                    
                    //Stack of Cards
                    ZStack {
                        
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
                        }
                        
                        // Iterate through the `stocks` array and create a `CardView` for each stock
                        ForEach(viewModel.stocks.indices, id: \.self) { index in
                            let stock = viewModel.stocks[index]
                            CardView(stock: stock)
                                .rotationEffect(.degrees(index == viewModel.stocks.count - 1 ? 4 : 0)) // Rotate the last card
                                .shadow(radius: index == viewModel.stocks.count - 1 ? 4 : 0)
                        }


                    }
                    
                    Spacer()
                    
                    // Use a DisclosureGroup for a better UX for Disclaimer
                    DisclosureGroup("                                                              Show Disclaimer", isExpanded: $showDisclaimer) {
                        Text("The information listed here does not constitute investment advice. No guarantee that the data is correct or up to date. Data Source RapidAPI.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding()
                            .transition(.slide)
                    }
                    .accentColor(.gray) // Customize the color to match your app's theme
                    .animation(.easeInOut, value: showDisclaimer)
                    .font(.footnote)
                    .padding()
                    
                    //Two buttons at the bottom. Use Geometry Reader fro responsive.
                    HStack() {
                        // Button to Reset Preferences
                        Button(action: {
                            tutorialManager.resetPreferencesScreenShown()
                        }) {
                            Label("Reset Filter", systemImage: "gear.badge.checkmark")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity) // Expand to take available space
                                .background(Color.black)
                                .cornerRadius(10)
                        }
                        
                        // Spacer to add some flexibility
                        Spacer()
                        
                        // Navigation Link to Watchlist
                        NavigationLink(destination: WatchListView(tutorialManager: tutorialManager)) {
                            Label("To Watchlist", systemImage: "list.bullet.rectangle.portrait")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity) // Expand to take available space
                                .background(Color.black)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom) // Add some padding at the bottom
                    
                } // VStack ends here
                .navigationTitle("Ideas for You") // Sets the navigation bar title
                .navigationBarTitleDisplayMode(.inline) // Sets the title display mode
                .onAppear {
                    print("Test onAPpear Investmentview")
    
                    self.showHandTap = true // Ensure the hand tap is shown every time the view appears
                        animate = true // Start the animation
                    
                    // Start a new hide action
                        DispatchQueue.main.asyncAfter(deadline: .now() + 28) {
                            self.showHandTap = false // Hide the hand tap image and text after 28 seconds
                        }
                }
                // Apply the gradient background to the entire VStack
                .background(BackgroundNavigationView())
            } // End of the NavigationView
            .navigationViewStyle(StackNavigationViewStyle()) // This forces the navigation view to display full-screen even on iPad
        }
}


//Preview
struct InvestmentView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock instance of TutorialManager and StockCoordinator to use in the preview
        let tutorialManager = TutorialManager()
        let viewModel = StockCoordinator()

        // Populate the viewModel's stocks array with sample data
        viewModel.stocks = [
            DetailStock(
                symbol: "AAPL",
                regularMarketPrice: 175.50,
                name: "Apple Inc.",
                matchScore: 0.98,
                history: [
                    StockHistory(timestamp: 1695609600, date: "2023-09-25", close: 174.50, volume: 50000000),
                    StockHistory(timestamp: 1695696000, date: "2023-09-26", close: 175.20, volume: 45000000),
                    StockHistory(timestamp: 1695782400, date: "2023-09-27", close: 176.80, volume: 47000000)
                ]
            ),
            DetailStock(
                symbol: "TSLA",
                regularMarketPrice: 245.80,
                name: "Tesla Inc.",
                matchScore: 0.97,
                history: [
                    StockHistory(timestamp: 1695609600, date: "2023-09-25", close: 244.30, volume: 30000000),
                    StockHistory(timestamp: 1695696000, date: "2023-09-26", close: 245.20, volume: 32000000),
                    StockHistory(timestamp: 1695782400, date: "2023-09-27", close: 246.10, volume: 31000000)
                ]
            )
        ]

        return InvestmentView(tutorialManager: tutorialManager)
            .environmentObject(viewModel)  // Provide the environment object for the preview
            .previewDevice("iPhone 14 Pro")  // Choose the device for preview
    }
}
