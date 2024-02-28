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
    
    @ObservedObject var matchService = MatchService()
    
    @State public var earningsPreference: Double = 5
    @State public var valuePreference: Double = 5
    @State public var dividendPreference: Double = 5
    
    @State private var currentQuestion = 1
    @State private var sliderValue: Double = 5
    @State private var sliderMoved: Bool = false
    


    var body: some View {
        VStack {
            Text("What is important to you when investing?")
                .font(.headline) // Changed to .headline for better visual hierarchy
                .bold() // Ensures the question is bold
            Text("Rate the importance")
            
            Spacer().frame(height: 10) // This Spacer pushes the button down


            switch currentQuestion {
            case 1:
                LottieView(name: "EarningsGrowth", loopMode: .loop)
                                    .frame(width: 260, height: 260)
                preferenceQuestionView(title: "Growing Revenues", sliderValue: $earningsPreference)
            case 2:
                LottieView(name: "HiddenValue", loopMode: .loop)
                                    .frame(width: 260, height: 260)
                preferenceQuestionView(title: "Hidden Value", sliderValue: $valuePreference)
            case 3:
                LottieView(name: "Dividends", loopMode: .loop)
                                    .frame(width: 260, height: 260)
                preferenceQuestionView(title: "Dividend Income", sliderValue: $dividendPreference, isLast: true)
            default:
                Button("Default") {
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
//                    print("Button pressed")
                    matchService.updateMatchScores(earningsPreference: Float(earningsPreference), peRatioPreference: Float(valuePreference), dividendPreference: Float(dividendPreference))
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
