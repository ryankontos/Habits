//
//  Event+Extension.swift
//  Habits
//
//  Created by Ryan on 21/11/2023.
//

import Foundation
#if canImport(ActivityKit)
import ActivityKit
#endif

extension Event {
    
    #if canImport(ActivityKit)
    
    func startLiveActivity() -> Activity<EventActivity>?  {
        
        let atributes = EventActivity(event: self)
        
        var cs = EventActivity.ContentState(state: .active)
        
        
        let activity = try? Activity.request(attributes: atributes, content: .init(state: cs, staleDate: nil))
        
        return activity
        
    }
    
    #endif
    
    func delete(cancelFirst: Bool = false) {
        
        let delay: Double = cancelFirst ? 1 : 0
        
        if cancelFirst {
            self.isCancelled = true
            self.habitHasDuration = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            let context = PersistenceController.shared.container.viewContext
            context.delete(self)
            
            DispatchQueue.main.async {
                try? context.save()
            }
        })
        
       
        
    }
    
    var dateInterval: DateInterval? {
        if let end = self.endDate {
            return DateInterval(start: self.startDate!, end: end)
        }
        return nil
        
    }
    
    static func getEventForURI(uri: URL) -> Event? {
        
        guard let objectID = PersistenceController.shared.container.viewContext.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: uri) else {
            return nil
        }
        
        guard let object = try? PersistenceController.shared.container.viewContext.existingObject(with: objectID) as? Event else {
            return nil
        }
        
        return object
        
    }
    
    
}


