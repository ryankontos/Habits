//
//  Habit+Extension.swift
//  Habits
//
//  Created by Ryan on 17/11/2023.
//

import Foundation
import SwiftUI
import CoreData
#if canImport(ActivityKit)
import ActivityKit
#endif

extension Habit: HabitDisplayable {
    
    public var eventsArray: [Event] {
        let set = self.events?.allObjects as? [Event] ?? []
        return set
    }
    
    var serializedColor: SerializableColor? {
            get {
                
                return SerializableColor(colorSpace: SerializableColor.SerializableColorSpace(rawValue: Int(colorSpaceValue)) ?? .sRGB,
                                         red: redValue,
                                         green: greenValue,
                                         blue: blueValue,
                                         alpha: alphaValue)
            }
            set {
                
                if let newValue = newValue {
                    colorSpaceValue = Int16(newValue.colorSpace.rawValue)
                    redValue = newValue.r
                    greenValue = newValue.g
                    blueValue = newValue.b
                    alphaValue = newValue.a
                }
                
               
            }
        }
    
    var color: Color {
        get {
            
            return serializedColor?.color ?? .brown
        }
        set(new) {
            serializedColor = SerializableColor(from: new)
        }
    }
    
    
    func createNewEvent() -> Event {
        
        let context = PersistenceController.shared.container.viewContext
        
            
        let event = Event(context: context)
        event.startDate = Date()
        event.habitHasDuration = self.hasDuration
            
        self.addToEvents(event)
        try? context.save()
            
        if event.habitHasDuration {
            
            #if canImport(ActivityKit)
            
            let _ = event.startLiveActivity()
            ActivityManager.updateActivities()
            
            #endif
            
        }
        
        return event
        
    }
    
        func fetchMostRecentEvent() -> Event? {
            guard let context = self.managedObjectContext else {
                print("No managed object context found")
                return nil
            }

            let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()

            // Create a sort descriptor to sort by date in descending order
            let sortDescriptor = NSSortDescriptor(key: "startDate", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]

            // Set a predicate to filter events for this habit
            let predicate = NSPredicate(format: "habit == %@", self)
            fetchRequest.predicate = predicate

            // We only want the most recent event
            fetchRequest.fetchLimit = 1

            do {
                let events = try context.fetch(fetchRequest)
                return events.first
            } catch {
                print("Error fetching event: \(error)")
                return nil
            }
        }
    
    static func fetchAll() -> [Habit] {
        
        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        return (try? PersistenceController.shared.container.viewContext.fetch(fetchRequest) as [Habit]) ?? .init()
        
    }
    
    static func getHabitForURI(uri: URL) -> Habit? {
        
        guard let objectID = PersistenceController.shared.container.viewContext.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: uri) else {
            return nil
        }
        
        guard let object = try? PersistenceController.shared.container.viewContext.existingObject(with: objectID) as? Habit else {
            return nil
        }
        
        return object
        
    }
    
    static func previewHabit(name: String = "Test Habit", color: Color = .purple, symbolName: String = "sparkles", hasDuration: Bool = false) -> Habit {
        
        let previewContext = PersistenceController.preview.container.viewContext
        
        let habit = Habit(context: previewContext)
        habit.name = name
        habit.color = color
        habit.symbolName = symbolName
        habit.hasDuration = hasDuration
        
        let event = Event(context: previewContext)
        event.habit = habit
        event.startDate = Date()
        event.endDate = nil
        event.habitHasDuration = hasDuration
        
        return habit
        
    }
    
    func displayData() -> HabitDisplayData {
        return HabitDisplayData(self)
    }
    
}


