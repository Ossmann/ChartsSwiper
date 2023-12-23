//
//  TutorialView.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 23/12/2023.
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.presentationMode) var presentationMode
        var tutorialManager: TutorialManager
    
    var body: some View {
        VStack{
            HStack {
                Image(systemName: "wand.and.stars.inverse")
                    .font(.system(size: 60))
                Text("This app helps you to find investment ideas.")
            }
            HStack {
                Text("Choose what is import to you and then swipe through your selection.")
                Image(systemName: "hand.tap")
                    .font(.system(size: 60))
            }
            HStack {
                Image(systemName: "filemenu.and.selection")
                    .renderingMode(.original)
                    .foregroundColor(Color.accentColor)
                    .font(.system(size: 60))
                Text("Save your favorite new stocks in your watchlist.")
            }
            Button("START") {
                        tutorialManager.setWelcomeScreenShown()
                        presentationMode.wrappedValue.dismiss()
                    }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.horizontal, 20)
            
        }.onAppear(perform: {
            UserDefaults.standard.welcomeScreenShown = true
        })
    }
}
