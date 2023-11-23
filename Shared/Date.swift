//
//  Date.swift
//  Habits
//
//  Created by Ryan on 19/11/2023.
//

import Foundation

extension Date {
    
    
func msTimerString(at date: Date = Date()) -> String {
    let timeInterval = date.timeIntervalSince(self)
    
    let minutes = Int(timeInterval) / 60 % 60
    let seconds = Int(timeInterval) % 60
    let centiseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100)

    return String(format: "%02d:%02d.%02d", minutes, seconds, centiseconds)
}
    
}
