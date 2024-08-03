//
//  Split.swift
//  NeoSplit
//
//  Created by Jerry on 02/08/2024.
//

import Foundation

struct Split: Identifiable, Equatable, Codable {
    let id: UUID
    var name: String
    var time: TimeInterval?
    
    var timeString: String {
        guard let time = time else { return "--:--:--.---" }
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.time = 0
    }
}
