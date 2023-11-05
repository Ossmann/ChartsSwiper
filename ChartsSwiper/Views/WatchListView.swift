//
//  WatchListView.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 5/11/2023.
//

import SwiftUI

struct WatchListView: View {
    var stocks: [Stock]

        init(stocks: [Stock]) {
            self.stocks = stocks
        }


    var body: some View {
        List {
            ForEach(stocks) { stock in
                ListRowView(stock: stock)
            }
        }
    }
}

