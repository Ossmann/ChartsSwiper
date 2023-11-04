import Charts
import SwiftUI

struct CardView: View {
    var stock: Stock
    @State private var offset = CGSize.zero
    @State private var color: Color = .white
    
    var body: some View {
        // arrange the cards of Stocks with Charts in a ZStack atop of each other
        ZStack {
            // format the cards
            Rectangle()
                .frame(width: 320, height: 420)
                .border(.white, width: 6.0)
                .cornerRadius(4)
                .foregroundColor(color.opacity(0.9))
                .shadow(radius: 4)
            
            VStack {
                Text(stock.symbol)
                    .font(.largeTitle)
                    .bold()
                Text("Price: $\(stock.history[0].close)")

                
                // Create the Chart
                Chart {
                    ForEach(stock.history, id: \.date) { history in
                        AreaMark(
                            x: .value("Date", history.date),
                            y: .value("Close", Double(history.close) ?? 0)
                        )
                        .interpolationMethod(.catmullRom) // Optional: Smooths the line
                    }
                }
                // display dates on x achsis (To DO)
                
                //display $ signs on y achsis
                .chartYAxis {
                    AxisMarks(preset: .extended, position: .leading, values: .automatic) {
                        AxisGridLine()
                        AxisValueLabel(format: .currency(code: "USD"))
                    }
                }
                .frame(width: 260, height: 200) // Adjust chart size
            }
        }
            // Rotation of Swipe
            .offset(x: offset.width, y: offset.height * 0.4)
            .rotationEffect(.degrees(Double(offset.width / 40)))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                        withAnimation {
                            changeColor(width: offset.width)
                        }
                    }
                    .onEnded { _ in
                        withAnimation {
                            swipeCard(width: offset.width)
                            changeColor(width: offset.width)
                        }
                    }
            )
    }
    
    // Add cards to watchlist or dismiss
    func swipeCard(width: CGFloat) {
        switch width {
        // Swipe left to dismiss a stock
        case -500...(-150):
            print("\(stock.symbol) removed")
            offset = CGSize(width: -500, height: 0)
        // Swipe right to add a new stock to the Watchlist
        case 150...500:
            print("\(stock.symbol) added")
            offset = CGSize(width: 500, height: 0)
        default:
            offset = .zero
        }
    }
    
    // change color to red if dismissed or green if added to watchlist
    func changeColor(width: CGFloat) {
        switch width {
        case -500...(-130):
            color = .red
        case 130...500:
            color = .green
        default:
            color = .white
        }
    }
}

// Helper struct to conform to 'Plottable'
struct Point: Identifiable {
    let id = UUID()
    let x: PlottableValue<String>
    let y: PlottableValue<Double>
}
