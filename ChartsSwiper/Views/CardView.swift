import Charts
import SwiftUI

struct CardView: View {
    var stock: DetailStock
    @State private var offset = CGSize.zero
    @State private var color: Color = .white
    @StateObject private var watchlistAdditionService = WatchlistAdditionService()
    
    var displayedDates: [String] {
        stock.history.enumerated().compactMap { index, history in
            index % 10 == 0 ? history.date : nil
        }
    }
    
    var body: some View {
        ZStack {
            // Glassmorphic card background
            RoundedRectangle(cornerRadius: 20)
                .fill(color) // Use a higher opacity for less gray appearance
                .frame(width: 320, height: 420)
                .blur(radius: 5) // Reduce the blur for less background color influence
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 1) // Border for the glassmorphic effect
                )
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10) // Optional shadow for depth


            // Card content
            VStack {
                Text(stock.name)
                    .font(.largeTitle)
                    .bold()
                Text(stock.symbol)
                    .font(.footnote)
                Text("Price: $" + String(format: "%.2f", stock.regularMarketPrice ?? 0))
                
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
                // display dates on x axis (To DO)
                
                //display only every 10th date on X Achsis
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        if let date = value.as(String.self), displayedDates.contains(date) {
                            AxisValueLabel()
                        }
//                        else {
////                            AxisTick(hidden: true)
//                            AxisValueLabel(hidden: true)
//                        }
                    }
                }
                
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
            watchlistAdditionService.addToWatchlist(cardStock: stock)
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
