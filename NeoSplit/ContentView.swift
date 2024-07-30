//
//  ContentView.swift
//  NeoSplit
//
//  Created by Jerry on 29/07/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var timerManager = TimerManager()
    
    var body: some View {
        VStack {
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
    }
}

class TimerManager: ObservableObject {
    @Published var elapsedTimeString: String = "00:00:00.000"
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
