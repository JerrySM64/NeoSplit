//
//  ContentView.swift
//  NeoSplit
//
//  Created by Jerry on 29/07/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var timerManager: TimerManager
    @StateObject private var keyEventHandler = KeyEventHandler()
    @State private var selectedFontName = UserDefaults.standard.string(forKey: "selectedFontName") ?? "Helvetica"
    @State private var backgroundColor: Color = Color(UserDefaults.standard.color(forKey: "backgroundColor") ?? .gray)
    @State private var textColor: Color = Color(UserDefaults.standard.color(forKey: "textColor") ?? .white)
    @State private var timerColor: Color = Color(UserDefaults.standard.color(forKey: "timerColor") ?? .green)
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(timerManager.gameName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(textColor)
                    .padding([.top, .leading, .trailing])
                        
                Text(timerManager.category)
                    .font(.title2)
                    .foregroundStyle(textColor)
                    .padding([.leading, .trailing, .bottom])
            }
            .background(Color.black)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 2)
            )
            .padding()
            
            List {
                ForEach(timerManager.splits) { split in
                    HStack {
                        Text(split.name)
                            .foregroundStyle(textColor)
                            .padding(5)
                        Spacer()
                        Text(split.timeString)
                            .foregroundStyle(timerColor)
                            .padding(5)
                    }
                }
            }
            .background(Color.black)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 2)
            )
            .padding()

            Text(timerManager.elapsedTimeString)
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .foregroundStyle(timerColor)
                .padding()
                .background(Color.black)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )
                .padding()
            
            HStack {
                Button(action: {
                    if !timerManager.isRunning {
                        timerManager.start()
                    } else {
                        timerManager.split()
                    }
                }) {
                    Text(timerManager.isRunning ? "Split" : "Start")
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(LiveSplitButtonStyle())
                
                Button(action: {
                    timerManager.stop()
                }) {
                    Text("Stop")
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(LiveSplitButtonStyle())
                
                Button(action: {
                    timerManager.reset()
                }) {
                    Text("Reset")
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(LiveSplitButtonStyle())
            }
            .padding()
        }
        .padding()
        .background(backgroundColor)
        .onAppear {
            keyEventHandler.timerManager = timerManager
            updateKeyBindings()
            NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: .main) { _ in
                updateSettings()
            }
            updateSettings()
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UserDefaults.didChangeNotification, object: nil)
        }
    }
    
    private func updateKeyBindings() {
        let startKey = UserDefaults.standard.string(forKey: "startKey") ?? "S"
        let stopKey = UserDefaults.standard.string(forKey: "stopKey") ?? "T"
        let resetKey = UserDefaults.standard.string(forKey: "resetKey") ?? "R"
        
        keyEventHandler.updateKeyBindings(startKey: startKey, stopKey: stopKey, resetKey: resetKey)
    }
    
    private func updateSettings() {
        selectedFontName = UserDefaults.standard.string(forKey: "selectedFontName") ?? "Helvetica"
        backgroundColor = Color(UserDefaults.standard.color(forKey: "backgroundColor") ?? .gray)
        textColor = Color(UserDefaults.standard.color(forKey: "textColor") ?? .white)
        timerColor = Color(UserDefaults.standard.color(forKey: "timerColor") ?? .green)
    }
}

struct LiveSplitButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TimerManager())
    }
}
