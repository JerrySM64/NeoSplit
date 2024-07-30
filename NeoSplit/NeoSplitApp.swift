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
        }
        .commands {
            CommandGroup(replacing: .appSettings) {
                Button(action: {
                    openPreferencesWindow()
                }) {
                    Text("Preferences")
                }
                .keyboardShortcut(",", modifiers: .command)
            }
        }
    }
    
    private func openPreferencesWindow() {
        if let window = NSApplication.shared.windows.first(where: { $0.identifier?.rawValue == "SettingsView" }) {
            window.makeKeyAndOrderFront(nil)
        } else {
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 300, height: 150),
                styleMask: [.titled, .closable, .resizable],
                backing: .buffered, defer: false)
            window.center()
            window.setFrameAutosaveName("Settings")
            window.isReleasedWhenClosed = false
            window.contentView = NSHostingView(rootView: SettingsView())
            window.makeKeyAndOrderFront(nil)
            window.identifier = NSUserInterfaceItemIdentifier("SettingsWindow")
        }
    }
}
