//
//  ListRowView.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 5/11/2023.
//

import SwiftUI

struct ListRowView: View {
    var stock: DetailStock

     var body: some View {
         HStack {
             Text("Stock: \(stock.symbol)")
             Spacer()
             Text("Price: \(stock.history[0].close)")
         }
     }
}
