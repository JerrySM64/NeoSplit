//
//  KeyEventHandler.swift
//  NeoSplit
//
//  Created by Jerry on 30/07/2024.
//

import Cocoa

class KeyEventHandler: ObservableObject {
    private var startKey: String = "S"
    private var stopKey: String = "T"
    private var resetKey: String = "R"
    weak var timerManager: TimerManager?
    
    init() {
        setupKeyEventMonitoring()
    }
    
    func updateKeyBindings(startKey: String, stopKey: String, resetKey: String) {
        self.startKey = startKey
        self.stopKey = stopKey
        self.resetKey = resetKey
    }
    
    private func setupKeyEventMonitoring() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyEvent(event)
            return event
        }
    }
    
    private func handleKeyEvent(_ event: NSEvent) {
        guard let characters = event.charactersIgnoringModifiers, let timerManager = timerManager else { return }
        
        switch characters {
            case startKey:
                timerManager.start()
            case stopKey:
                timerManager.stop()
            case resetKey:
                timerManager.reset()
            default:
                break
        }
    }
}
