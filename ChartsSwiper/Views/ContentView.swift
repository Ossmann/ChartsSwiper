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
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                            HStack {
                                Spacer() // Pushes the arrow to the right
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
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
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(5)
                
                Spacer()
                
                // Sign In Button
                Button("Sign in") {
                    // Action for sign in
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.pink)
                .cornerRadius(5)

                Spacer()
            }
            .padding(.horizontal) // This will ensure the padding is uniform on both sides
            .background(Color(red: 255/255, green: 105/255, blue: 180/255))
            .edgesIgnoringSafeArea(.all)
        }
    }
}
