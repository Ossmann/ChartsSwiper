import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(
        entity: DBStock.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \DBStock.symbol, ascending: true)],
        predicate: NSPredicate(format: "symbol == %@", "AAPL")
    ) var aaplStocks: FetchedResults<DBStock>

    var body: some View {
        NavigationView {
            VStack {
                header
                stocksList
                footer
            }
            .navigationTitle("Stocks Overview")
        }
    }

    // MARK: - Subviews
    private var header: some View {
        VStack {
            Text("Welcome to the New App")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)

            NavigationLink(destination: InvestmentView()) {
                Text("Explore Investments")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
        }
    }

    private var stocksList: some View {
        List(aaplStocks, id: \.self) { stock in
            HStack {
                Text(stock.symbol ?? "Unknown")
                    .fontWeight(.semibold)
                Spacer()
                Text(String(format: "PE Ratio: %.2f", stock.peRatio))
                    .foregroundColor(stock.peRatio > 0 ? .green : .red)
            }
            .padding(.vertical, 8)
        }
        .listStyle(PlainListStyle())
        //check error in fetching
        .onAppear {
                print("Fetched \(aaplStocks.count) AAPL stocks")
            }
    }

    private var footer: some View {
        VStack {
            Divider()
            HStack {
                Image(systemName: "c.circle")
                Text("Jakob Ossmann")
                    .font(.footnote)
            }
            .padding(.bottom, 20)
        }
    }
}
