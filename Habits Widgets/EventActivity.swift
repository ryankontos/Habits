//
//  EventActivity.swift
//  Habits
//
//  Created by Ryan on 17/11/2023.
//

import Foundation
import SwiftUI
#if canImport(ActivityKit)
import ActivityKit



struct EventActivity: ActivityAttributes {
   
    init(event: Event, preview: Bool = false) {
        
        self.codedColor = SerializableColor(from: event.habit!.color)
        self.habitID = event.habit!.objectID.uriRepresentation()
        self.startDate = event.startDate!
        self.eventID = event.objectID.uriRepresentation()
        self.habitData = event.habit!.displayData()
        
    }
    
    struct ContentState: Codable & Hashable {
        
        var state: EventActivity.StateOption
        
        var undoable: Bool {
            return state == .cancelled || state == .saved
        }
        
    }
    
    var color: Color {
        
        return codedColor.color
        
    }
    
   
    private var codedColor: SerializableColor
    
    var habitID: URL
    var startDate: Date
    
    var habitData: HabitDisplayData
    
    var eventID: URL
    
    
    enum StateOption: Codable {
        
        case active
        case paused
        case cancelled
        case saved
        case destroyed
        
    }
    
    static func previewActivity() -> EventActivity {
        
        .init(event: Habit.previewHabit().eventsArray.first!, preview: true)
        
    }
    
    
}

#endif
