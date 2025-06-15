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
            .cancel: "Cancel Event", .complete : "Complete Event", .requestCancel : "Confirm Event Cancellation", .undoCancel: "Reject Cancel Event", .undoComplete: "Undo Complete"]
        
        case complete
        case cancel
        case requestCancel
        case undoComplete
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
            
            #if canImport(ActivityKit)
            
            switch type {
                
            case .complete:
                await ActivityManager.endEventWith(url: activityID!)
                event.endDate = Date()
                
                try? PersistenceController.shared.container.viewContext.save()
                
            case .cancel:
                
                await ActivityManager.endEventWith(url: activityID!)
                event.delete(cancelFirst: true)
                
                DispatchQueue.main.async {
                    try? PersistenceController.shared.container.viewContext.save()
                }
                    
                
              
                
                
            case .requestCancel:
                await ActivityManager.updateActivityWith(url: activityID!, using: .init(state: .paused))
                
                try? await Task.sleep(nanoseconds: 4_000_000_000)
                        
                await ActivityManager.updateActivityWith(url: activityID!, using: .init(state: .active))
                
            case .undoCancel:
                await ActivityManager.updateActivityWith(url: activityID!, using: .init(state: .active))
            case .undoComplete:
                await ActivityManager.updateActivityWith(url: activityID!, using: .init(state: .active))
            }
            
            #endif
            
        }
        
        try? PersistenceController.shared.container.viewContext.save()
        
       
        return .result()
    }
}
