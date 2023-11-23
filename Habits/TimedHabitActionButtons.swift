//
//  TimedHabitActionButtons.swift
//  Habits
//
//  Created by Ryan on 20/11/2023.
//

import SwiftUI
import CoreData
import AppIntents

struct TimedHabitActionButtons: View {
    
    enum ActionMode {
        
        case intent
        case action((() -> Void))
        
    }
    
    init(event: Event, buttonSpacing: CGFloat, buttonSize: CGFloat, buttonFontSize: CGFloat, actionMode: ActionMode = .action({})) {
        self.eventID = event.objectID.uriRepresentation()
        self.color = event.habit?.color ?? .accentColor
        self.buttonSpacing = buttonSpacing
        self.buttonSize = buttonSize
        self.buttonFontSize = buttonFontSize
        self.actionMode = actionMode
    }
    
    init(eventID: URL, color: Color, buttonSpacing: CGFloat, buttonSize: CGFloat, buttonFontSize: CGFloat, actionMode: ActionMode = .intent) {
        self.eventID = eventID
        self.color = color
        self.buttonSpacing = buttonSpacing
        self.buttonSize = buttonSize
        self.buttonFontSize = buttonFontSize
        self.actionMode = actionMode
    }
    
    private var eventID: URL
    private var color: Color
    
    private var buttonSpacing: CGFloat
    private var buttonSize: CGFloat
    private var buttonFontSize: CGFloat
    
    private var actionMode: ActionMode
    
    
    var body: some View {
        
        
        
        HStack(spacing: buttonSpacing) {
            
            switch actionMode {
            case .intent:
                
                Button(intent: CompleteTimedEventIntent(type: .requestCancel, id: eventID)) {
                    cancelButtonView
                }
                
                Button(intent: CompleteTimedEventIntent(type: .complete, id: eventID)) {
                    saveButtonView
                }
                
            case .action(let action):
                
                Button(action: {
                    
                    action()
                    
                    Task {
                        try? await CompleteTimedEventIntent(type: .cancel, id: eventID).perform()
                    }
                    
                }) {
                    cancelButtonView
                }
                
                Button(action: {
                    
                    action()
                    
                    Task {
                        try? await CompleteTimedEventIntent(type: .complete, id: eventID).perform()
                    }
                    
                }) {
                    saveButtonView
                }
                
            }
            
      
            
        }
        .buttonStyle(.borderless)
        
    }
    
    var saveButtonView: some View {
        CircleIconButtonView(color: color, iconName: "checkmark", buttonSize: buttonSize, fontSize: buttonFontSize)
    }
    
    var cancelButtonView: some View {
        CircleIconButtonView(color: .gray, iconName: "xmark", buttonSize: buttonSize, fontSize: buttonFontSize)
    }
}

#Preview {
    TimedHabitActionButtons(eventID: URL(string: "www.apple.com")!, color: .blue, buttonSpacing: 10, buttonSize: 150, buttonFontSize: 60)
}
