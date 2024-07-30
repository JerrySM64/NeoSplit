//
//  SettingsWindowController.swift
//  NeoSplit
//
//  Created by Jerry on 30/07/2024.
//

import Cocoa
import SwiftUI

class SettingsWindowController: NSWindowController, NSWindowDelegate {
    static let shared = SettingsWindowController()

    private init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 150),
            styleMask: [.titled, .closable],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Settings")
        window.isReleasedWhenClosed = false
        window.contentView = NSHostingView(rootView: SettingsView().environmentObject(TimerManager()))
        super.init(window: window)
        self.window?.delegate = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showWindow() {
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true) // Ensure window is brought to the front
    }

    func windowWillClose(_ notification: Notification) {
        self.window?.orderOut(nil)
    }
}
