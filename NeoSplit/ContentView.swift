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
            NotificationCenter.default.addObserver(
                forName: UserDefaults.didChangeNotification,
                object: nil,
                queue: .main
            ) { _ in
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

class TimerManager: ObservableObject {
    @Published var elapsedTimeString: String = "00:00:00.000"
    @Published var gameName: String = UserDefaults.standard.string(forKey: "gameName") ?? "Unknown Game"
    
    private var timer: Timer?
    private var startDate: Date?
    private var pausedTime: TimeInterval = 0
    
    func start() {
        if timer == nil {
            startDate = Date()
            timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
                self.updateElapsedTime()
            }
        }
    }
    
    func stop() {
        if let startDate = startDate {
            pausedTime += Date().timeIntervalSince(startDate)
        }
        timer?.invalidate()
        timer = nil
        startDate = nil
    }
    
    func reset() {
        stop()
        pausedTime = 0
        startDate = nil
        elapsedTimeString = "00:00:00.000"
    }
    
    private func updateElapsedTime() {
        guard let startDate = startDate else { return }
        let currentElapsedTime = Date().timeIntervalSince(startDate)
        let totalElapsedTime = pausedTime + currentElapsedTime
        
        let hours = Int(totalElapsedTime) / 3600
        let minutes = Int(totalElapsedTime) / 60 % 60
        let seconds = Int(totalElapsedTime) % 60
        let milliseconds = Int((totalElapsedTime - Double(Int(totalElapsedTime))) * 1000)
        elapsedTimeString = String(format: "%02i:%02i:%02i.%03i", hours, minutes, seconds, milliseconds)
    }
    
    func saveGameName(_ name: String) {
        gameName = name
        UserDefaults.standard.set(name, forKey: "gameName")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TimerManager())
    }
}
