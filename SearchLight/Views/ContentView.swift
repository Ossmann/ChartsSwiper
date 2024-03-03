//
//  ContentView.swift
//  ChartsSwiper
//
//  Created by Jakob Ossmann on 5/11/2023.
//
// We have a WelcomeScreen and the Preference selection that only appear once.
// InvestmentView is where the main content starts
//

import SwiftUI
import CoreData
import Foundation

struct ContentView: View {
    //State Variable so tutorial is only viewed once
    @StateObject private var tutorialManager = TutorialManager()

    var body: some View {
        if tutorialManager.welcomeScreenShown {
            if tutorialManager.preferencesScreenShown {
                InvestmentView()
            } else {
                PreferencesView(tutorialManager: tutorialManager)
            }
        } else {
            TutorialView(tutorialManager: tutorialManager)
        }
    }

    private var footer: some View {
        VStack {
            Divider()
            HStack {
                Image(systemName: "c.circle")
                Text("Jakob Ossmann")
                    .font(.footnote)
            }
            .padding(.bottom, 20)
        }
    }
}

// Observable object to manage the welcome screen state
class TutorialManager: ObservableObject {
    @Published var welcomeScreenShown: Bool
    @Published var preferencesScreenShown: Bool

    init() {
        welcomeScreenShown = UserDefaults.standard.welcomeScreenShown
        preferencesScreenShown = UserDefaults.standard.preferencesScreenShown
    }

    func setWelcomeScreenShown() {
        UserDefaults.standard.welcomeScreenShown = true
        welcomeScreenShown = true
    }
    
    func setPreferencesScreenShown() {
            UserDefaults.standard.preferencesScreenShown = true
            preferencesScreenShown = true
        }
}

// Extension to UserDefaults to simplify the welcome screen flag access
extension UserDefaults {
    var welcomeScreenShown: Bool {
        get { bool(forKey: "welcomeScreenShown") }
        set { set(newValue, forKey: "welcomeScreenShown") }
    }
    
    var preferencesScreenShown: Bool {
            get { bool(forKey: "preferencesScreenShown") }
            set { set(newValue, forKey: "preferencesScreenShown") }
        }
}
