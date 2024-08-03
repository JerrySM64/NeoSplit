//
//  NeoSplitApp.swift
//  NeoSplit
//
//  Created by Jerry on 29/07/2024.
//

import SwiftUI

@main
struct NeoSplitApp: App {
    @StateObject private var timerManager = TimerManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerManager)
                .frame(minWidth: 460, minHeight: 570)
                .onAppear {
                    if let window = NSApplication.shared.windows.first {
                        window.minSize = NSSize(width: 460, height: 570)
                    }
                }
        }
        .commands {
            CommandGroup(replacing: .appSettings) {
                Button(action: {
                    SettingsWindowController.shared.showWindow()
                }) {
                    Text("Settings…")
                }
                .keyboardShortcut(",", modifiers: .command)
            }
        }
    }
}
