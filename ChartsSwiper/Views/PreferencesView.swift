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

    var body: some View {
        VStack {
            Text("What is important to you when investing?")

            switch currentQuestion {
            case 1:
                preferenceQuestionView(title: "Revenue Growth", sliderValue: $sliderValue)
            case 2:
                preferenceQuestionView(title: "Hidden Value", sliderValue: $sliderValue)
            case 3:
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
            Slider(value: sliderValue, in: 1...10, step: 1)
            if isLast {
                Text("Continue with \(Int(sliderValue.wrappedValue))")
                Button("To my recommendations") {
                    tutorialManager.setPreferencesScreenShown()
                }
            } else {
                Button("Continue with \(Int(sliderValue.wrappedValue))") {
                    currentQuestion += 1
                }
            }
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView(tutorialManager: TutorialManager())
    }
}

