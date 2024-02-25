//
//  PreferencesView.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 5/11/2023.
//

import SwiftUI
import Lottie

struct PreferencesView: View {
    @ObservedObject var tutorialManager: TutorialManager
    
    @State private var currentQuestion = 1
    @State private var sliderValue: Double = 5
    @State private var sliderMoved: Bool = false


    var body: some View {
        VStack(spacing: 60) {
            Text("What is important to you when investing?")
                .font(.headline) // Changed to .headline for better visual hierarchy
                .bold() // Ensures the question is bold
            Text("Rate the importance")
            
            Spacer().frame(height: 10) // This Spacer pushes the button down


            switch currentQuestion {
            case 1:
                LottieView(name: "EarningsGrowth", loopMode: .loop)
                                    .frame(width: 260, height: 260) // Set your frame here
                preferenceQuestionView(title: "Growing Revenues", sliderValue: $sliderValue)
            case 2:
                LottieView(name: "HiddenValue", loopMode: .loop)
                                    .frame(width: 260, height: 260) // Set your frame here
                preferenceQuestionView(title: "Hidden Value", sliderValue: $sliderValue)
            case 3:
                LottieView(name: "Dividends", loopMode: .loop)
                                    .frame(width: 260, height: 260)
                preferenceQuestionView(title: "Dividend Income", sliderValue: $sliderValue, isLast: true)
            default:
                Button("To my recommendations") {
                    tutorialManager.setPreferencesScreenShown()
                }
            }
        }
    }

    private func preferenceQuestionView(title: String, sliderValue: Binding<Double>, isLast: Bool = false) -> some View {
        VStack {
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
