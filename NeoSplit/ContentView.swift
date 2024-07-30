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
    
    var body: some View {
        VStack {
            Text(timerManager.gameName)
                .font(.title)
                .padding()
            
            Text(timerManager.elapsedTimeString)
                .font(.largeTitle)
                .padding()
            
            HStack {
                Button(action: {
                    timerManager.start()
                }) {
                    Text("Start")
                        .padding()
                }
                
                Button(action: {
                    timerManager.stop()
                }) {
                    Text("Stop")
                        .padding()
                }
                
                Button(action: {
                    timerManager.reset()
                }) {
                    Text("Reset")
                        .padding()
                }
            }
        }
        .padding()
        .onAppear {
            keyEventHandler.timerManager = timerManager
            updateKeyBindings()
            NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: .main) { _ in
                updateKeyBindings()
            }
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TimerManager())
    }
}
