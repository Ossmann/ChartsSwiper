
import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var viewModel = StockViewModel() // Instance of StockViewModel

    var body: some View {
            VStack {
                ZStack {
                    ForEach(viewModel.stocks) { stock in
                        CardView(stock: stock)
                    }
                }
            }// Fetch data when the view appears
            .onAppear{
                viewModel.fetchData()
            }
        
        Text("Demo Data: AlphaVantage.co, No commercial use")
            .font(.footnote) // This makes the font smaller

        }
    
}
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


