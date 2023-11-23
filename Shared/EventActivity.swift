//
//  EventActivity.swift
//  Habits
//
//  Created by Ryan on 17/11/2023.
//

import Foundation
import SwiftUI
import ActivityKit


struct EventActivity: ActivityAttributes {
   
    init(event: Event, preview: Bool = false) {
        
        self.codedColor = SerializableColor(from: event.habit!.color)
        self.habitName = event.habit!.name!
        self.startDate = event.startDate!
        self.symbolName = event.habit!.symbolName!
        self.eventID = event.objectID.uriRepresentation()
        
    }
    
    struct ContentState: Codable & Hashable {
       
        var userWantsToCancel = false
        var ended = false
        
    }
    
    var color: Color {
        
        return codedColor.color
        
    }
    
    private var codedColor: SerializableColor
    var habitName: String
    var startDate: Date
    var symbolName: String
    
    var eventID: URL
    
}
