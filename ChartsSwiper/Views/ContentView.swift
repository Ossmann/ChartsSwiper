import SwiftUI

struct ContentView: View {
    @State private var animate = false  // State variable to control animation
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // Header
                Text("WELCOME TO THE NEW APP")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                
                // Buttons
                Group {
                    Button("Quick balance", action: {})
                    Button("Cardless Cash", action: {})
                    NavigationLink(destination: InvestmentView()) {
                        ZStack {
                            Text("Explore Investments")
                                .frame(maxWidth: .infinity, alignment: .center)
                            HStack {
                                Spacer() // Pushes the arrow to the right
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(Color(red: 0.855, green: 0.09, blue: 0.063)) // #da1710
                                    .offset(x: animate ? 10 : 0)
                                    .animation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: animate)
                                    .onAppear {
                                        animate = true
                                    }
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
                .background(.white)
                .cornerRadius(5)
                
                Spacer()
                
                // WestPac Logo
                Image("westpaccomau-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)

                Spacer()
                HStack {
                    Image(systemName: "c.circle")
                    Text("Jakob Ossmann")
                }
                    .font(.footnote) // This makes the font smaller
                Spacer()
            }
            .padding(.horizontal) // This will ensure the padding is uniform on both sides
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(red: 153/255, green: 0, blue: 0), Color(red: 153/255, green: 26/255, blue: 214/255)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}

