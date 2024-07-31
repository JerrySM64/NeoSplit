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
            Section(header: Text("Game Settings").font(.headline).foregroundStyle(.white)) {
                TextField("Game", text: $gameName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: gameName) { newValue in
                        timerManager.saveGameName(newValue)
                    }
                TextField("Category", text: $category)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: category) { newValue in
                        timerManager.saveCategory(newValue)
                    }
            }
            .listRowBackground(Color.black)
            
            Section(header: Text("Key Bindings").font(.headline).foregroundStyle(.white)) {
                HStack {
                    Text("Start").foregroundStyle(.white)
                    TextField("", text: $startKey)
                        .frame(width: 50)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text("Stop").foregroundStyle(.white)
                    TextField("", text: $stopKey)
                        .frame(width: 50)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text("Reset").foregroundStyle(.white)
                    TextField("", text: $resetKey)
                        .frame(width: 50)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .listRowBackground(Color.black)
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
