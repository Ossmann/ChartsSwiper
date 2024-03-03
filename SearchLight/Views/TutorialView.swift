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
    @State private var showFirst = false
    @State private var showSecond = false
    @State private var showThird = false
    
    let hStackHeight: CGFloat = 80 // Set a fixed height for each HStack
    let hStackWidth: CGFloat = 300 // Set a fixed width for each HStack
    
    var body: some View {
        ZStack {
            
            // Content
            VStack(spacing: 20) {
                if showFirst {
                    glassmorphicHStack(
                        text: "This app helps you to find investment ideas.",
                        imageName: "wand.and.stars.inverse"
                    )
                    .transition(.move(edge: .trailing))
                }
                
                if showSecond {
                    glassmorphicHStack(
                        text: "Choose what is important to you and then swipe through your selection.",
                        imageName: "hand.tap",
                        isImageLast: true
                    )
                    .transition(.move(edge: .trailing))
                }
                
                if showThird {
                    glassmorphicHStack(
                        text: "Save your favorite new stocks in your watchlist.",
                        imageName: "tray.and.arrow.down"
                    )
                    .transition(.move(edge: .trailing))
                }
                
                if showThird { // Only show the START button after the last HStack has appeared
                    
                    Spacer().frame(height: 16) // This Spacer pushes the button down
                    
                    Button("START") {
                        tutorialManager.setWelcomeScreenShown()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black) // Make the button black
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                }
            }
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showFirst = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showSecond = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation {
                            showThird = true
                        }
                    }
                }
            }
        })
    }
    
    @ViewBuilder
    private func glassmorphicHStack(text: String, imageName: String, isImageLast: Bool = false) -> some View {
        HStack {
            if !isImageLast {
                Image(systemName: imageName)
                    .font(.system(size: 60))
            }
            Text(text)
            if isImageLast {
                Image(systemName: imageName)
                    .font(.system(size: 60))
            }
        }
        .frame(width: hStackWidth, height: hStackHeight)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.4))
                .blur(radius: 10) // Increased blur for a more glass-like effect
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.2), lineWidth: 2) // Adjust stroke opacity for better effect
        )
        .shadow(color: Color.white.opacity(0.4), radius: 5, x: 5, y: 5) // Add a slight shadow to the
        
    }
}

