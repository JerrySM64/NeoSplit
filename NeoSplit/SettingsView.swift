//
//  SettingsView.swift
//  NeoSplit
//
//  Created by Jerry on 30/07/2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("startKey") private var startKey: String = "S"
    @AppStorage("stopKey") private var stopKey: String = "T"
    @AppStorage("resetKey") private var resetKey: String = "R"
    @EnvironmentObject var timerManager: TimerManager
    @State private var gameName: String = UserDefaults.standard.string(forKey: "gameName") ?? ""
    @State private var category: String = UserDefaults.standard.string(forKey: "category") ?? ""

    var body: some View {
        Form {
            Section(header: Text("Game Settings")) {
                TextField("Game", text: $gameName)
                    .onChange(of: gameName) { newValue in
                        timerManager.saveGameName(newValue)
                    }
                TextField("Category", text: $category)
                    .onChange(of: category) { newValue in
                        timerManager.saveCategory(newValue)
                    }
            }
            
            Section(header: Text("Key Bindings")) {
                HStack {
                    Text("Start")
                    TextField("", text: $startKey)
                        .frame(width: 50)
                        .multilineTextAlignment(.center)
                }
                HStack {
                    Text("Stop")
                    TextField("", text: $stopKey)
                        .frame(width: 50)
                        .multilineTextAlignment(.center)
                }
                HStack {
                    Text("Reset")
                    TextField("", text: $resetKey)
                        .frame(width: 50)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
        .onAppear {
            gameName = timerManager.gameName
            category = timerManager.category
        }
        .frame(width: 300, height: 200)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(TimerManager())
    }
}
