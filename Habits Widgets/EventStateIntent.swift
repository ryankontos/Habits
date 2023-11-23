//
//  EventStateIntent.swift
//  Habits
//
//  Created by Ryan on 20/11/2023.
//

import Foundation
import AppIntents

struct CompleteTimedEventIntent: LiveActivityIntent {
    
    init() {
        
    }
  
    enum CompletionType: String, AppEnum {
        
        static var typeDisplayRepresentation: TypeDisplayRepresentation = "EventCompletionType"
        
        static var caseDisplayRepresentations: [CompleteTimedEventIntent.CompletionType : DisplayRepresentation] = [
            .cancel: "Cancel Event", .complete : "Complete Event", .requestCancel : "Confirm Event Cancellation", .undoCancel: "Reject Cancel Event"]
        
        case complete
        case cancel
        case requestCancel
        case undoCancel
    }
    
    static var title: LocalizedStringResource = "Set Event State"
    
    @Parameter(title: "Type")
    var type: CompletionType
    
    @Parameter(title: "ID")
    var activityID: URL?
    
    
    init(type: CompletionType, id: URL) {
        self.type = type
        self.activityID = id
    }
    
    func perform() async throws -> some IntentResult {
        
       
        
        FeedbackManager.shared.selectionChanged()
        
     
        
        if let event = Event.getEventForURI(uri: activityID!) {
            
            switch type {
                
            case .complete:
                await ActivityManager.endEventWith(url: activityID!)
                event.endDate = Date()
            case .cancel:
                
                await ActivityManager.endEventWith(url: activityID!)
                event.delete(cancelFirst: true)
                
                
            case .requestCancel:
                await ActivityManager.updateActivityWith(url: activityID!, using: .init(userWantsToCancel: true))
                
                try? await Task.sleep(nanoseconds: 4_000_000_000)
                        
                await ActivityManager.updateActivityWith(url: activityID!, using: .init(userWantsToCancel: false))
                
            case .undoCancel:
                await ActivityManager.updateActivityWith(url: activityID!, using: .init(userWantsToCancel: false))
            }
            
            
        }
        
       
        return .result()
    }
}
