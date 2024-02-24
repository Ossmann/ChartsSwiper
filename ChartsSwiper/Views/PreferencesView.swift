//
//  PreferencesView.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 5/11/2023.
//

import SwiftUI

struct PreferencesView: View {
    @ObservedObject var tutorialManager: TutorialManager
    
    @State private var currentQuestion = 1
    @State private var sliderValue: Double = 5
    @State private var sliderMoved: Bool = false


    var body: some View {
        VStack(spacing: 80) {
            Text("What is important to you when investing?")
                .font(.headline) // Changed to .headline for better visual hierarchy
                .bold() // Ensures the question is bold
            
            Spacer().frame(height: 20) // This Spacer pushes the button down


            switch currentQuestion {
            case 1:
                preferenceQuestionView(imageName: "chart.bar", title: "Revenue Growth", sliderValue: $sliderValue)
            case 2:
                preferenceQuestionView(imageName: "hand.coin", title: "Hidden Value", sliderValue: $sliderValue)
            case 3:
                preferenceQuestionView(imageName: "arrow.up.forward", title: "Dividend Income", sliderValue: $sliderValue, isLast: true)
            default:
                Button("To my recommendations") {
                    tutorialManager.setPreferencesScreenShown()
                }
            }
        }
    }

    private func preferenceQuestionView(imageName: String, title: String, sliderValue: Binding<Double>, isLast: Bool = false) -> some View {
        VStack {
            Image(systemName: imageName)
            Text(title)
                .bold() // Apply bold styling to the title
            Text("\(Int(sliderValue.wrappedValue))")
            Slider(value: sliderValue, in: 1...10, step: 1)
            // Detect changes to the slider value
                .onChange(of: sliderValue.wrappedValue) { _ in
                    sliderMoved = true
                }
            
            Spacer().frame(height: 16) // This Spacer pushes the button down
            
            if isLast {
                Button("To my recommendations") {
                    tutorialManager.setPreferencesScreenShown()
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.black) // Make the button black
                .cornerRadius(10)
                .padding(.horizontal, 10)
            } else {
                //only show if Slider was moved
                if sliderMoved {
                    Button("Continue") {
                        currentQuestion += 1
                        // Reset sliderMoved for the next question
                        sliderMoved = false
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black) // Make the button black
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                }
            }
        }
    }
}




