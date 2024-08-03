//
//  TimerManager.swift
//  NeoSplit
//
//  Created by Jerry on 30/07/2024.
//

import SwiftUI
import Combine

class TimerManager: ObservableObject {
    @Published var elapsedTimeString: String = "00:00:00.000"
    @Published var gameName: String = UserDefaults.standard.string(forKey: "gameName") ?? "Unknown Game"
    @Published var category: String = UserDefaults.standard.string(forKey: "category") ?? "Any%"
    @Published var splits: [Split] = UserDefaults.standard.splits(forKey: "splits") ?? [Split(name: "Split 1")]
    @Published var currentSplitIndex: Int = 0
    @Published var isRunning: Bool = false

    private var timer: Timer?
    private var startDate: Date?
    private var pausedTime: TimeInterval = 0

    func start() {
        if timer == nil {
            startDate = Date()
            timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
                self.updateElapsedTime()
            }
            isRunning = true
            currentSplitIndex = 0
        }
    }

    func stop() {
        if let startDate = startDate {
            pausedTime += Date().timeIntervalSince(startDate)
        }
        timer?.invalidate()
        timer = nil
        startDate = nil
        isRunning = false
    }

    func reset() {
        stop()
        pausedTime = 0
        startDate = nil
        elapsedTimeString = "00:00:00.000"
        for i in splits.indices {
            splits[i].time = nil
        }
        currentSplitIndex = 0
    }

    func split() {
        if currentSplitIndex < splits.count {
            if let startDate = startDate {
                let currentElapsedTime = Date().timeIntervalSince(startDate)
                let totalElapsedTime = pausedTime + currentElapsedTime
                splits[currentSplitIndex].time = totalElapsedTime
                currentSplitIndex += 1
                if currentSplitIndex >= splits.count {
                    stop()
                }
            }
        }
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

    func saveCategory(_ category: String) {
        self.category = category
        UserDefaults.standard.set(category, forKey: "category")
    }

    func updateSplits(_ splits: [Split]) {
        self.splits = splits
        UserDefaults.standard.setSplits(splits, forKey: "splits")
    }
}
