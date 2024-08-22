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
    private var undoSplitKey: String = "U"
    private var skipSplitKey: String = "K"
    weak var timerManager: TimerManager?
    
    init() {
        setupKeyEventMonitoring()
    }
    
    func updateKeyBindings(startKey: String, stopKey: String, resetKey: String, undoSplitKey: String, skipSplitKey: String) {
        self.startKey = startKey
        self.stopKey = stopKey
        self.resetKey = resetKey
        self.undoSplitKey = undoSplitKey 
        self.skipSplitKey = skipSplitKey
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
                if !timerManager.isRunning {
                    timerManager.start()
                } else {
                    timerManager.split()
                }
            case stopKey:
                timerManager.stop()
            case resetKey:
                timerManager.reset()
            case undoSplitKey:
                timerManager.undoSplit()
            case skipSplitKey:
                timerManager.skipSplit()
            default:
                break
        }
    }
}
