//
//  CardView.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 4/11/2023.
//

import SwiftUI

struct CardView: View {
    var stock: Stock
    @State private var offset = CGSize.zero
    @State private var color: Color = .yellow
 
    
    var body: some View {
        // arrage the cards of Stocks with Charts in a Zstack atop of each other
        ZStack {
            //format the cards
            Rectangle()
                .frame(width: 320, height: 420)
                .border(.white, width: 6.0)
                .cornerRadius(4)
                .foregroundColor(color.opacity(0.9))
                .shadow(radius: 4)
            HStack {
                Text(stock.history[0].close)
                Text(stock.symbol)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            }
        }
        //Rotation of Swipe
        .offset(x: offset.width, y: offset.height * 0.4)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .gesture(
        DragGesture()
            .onChanged { gesture in
                offset = gesture.translation
                withAnimation {
                    changeColor(width: offset.width)
                }
            } .onEnded { _ in
                withAnimation {
                    swipeCard(width: offset.width)
                    changeColor(width: offset.width)
                }
                
            }
        )
    }
    //Add cards to watchlist or dismiss
    func swipeCard(width: CGFloat) {
        switch width {
        //Swipe left to dismiss a stock
        case -500...(-150):
            print("\(stock.symbol) removed")
            offset = CGSize(width: -500, height: 0)
        //Swipe right to add a new stock to the Watchlist
        case 150...(500):
            print("\(stock.symbol) added")
            offset = CGSize(width: 500, height: 0)
        default:
            offset = .zero
        }
    }
    
    //change color to red if dismissed or green if added to watchlist
    func changeColor(width: CGFloat) {
        switch width {
        case -500...(-130):
            color = .red
        case 130...500:
            color = .green
        default:
            color = .yellow
        }
    }

    
    
}
//
//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView(security: stock.symbol)
//    }
//}
