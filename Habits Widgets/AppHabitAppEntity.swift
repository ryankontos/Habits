//
//  AppHabitAppEntity.swift
//  Habits
//
//  Created by Ryan on 21/11/2023.
//

import Foundation
import AppIntents
import CoreData
import SwiftUI

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct HabitAppEntity: AppEntity {
   
    static var defaultQuery = HabitAppEntityQuery()

    var color: Color
    var id: String // if your identifier is not a String, conform the entity to EntityIdentifierConvertible.
    var url: URL
    var displayString: String
    var symbolName: String
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(displayString)")
    }

    init(habit: Habit) {
        self.id = habit.objectID.uriRepresentation().absoluteString
        self.url = habit.objectID.uriRepresentation()
        self.displayString = habit.name!
        self.color = habit.color
        self.symbolName = habit.symbolName!
    }
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Habits")

    struct HabitAppEntityQuery: EntityStringQuery {
        func entities(for identifiers: [HabitAppEntity.ID]) async throws -> [HabitAppEntity] {
            
            var result = [HabitAppEntity]()
            
            for id in identifiers {
                
                if let habit = Habit.getHabitForURI(uri: URL(string: id)!) {
                    result.append(HabitAppEntity(habit: habit))
                }
                
            }
            
            return result
        }

        func entities(matching string: String) async throws -> [HabitAppEntity] {
            // TODO: return AppHabitAppEntity entities matching the search string here.
            
           
            
            let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
            
            let habits = try! PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            return habits.map({ HabitAppEntity(habit: $0) })
           
        }
    
        func defaultResult() async -> [HabitAppEntity]? {
                try! await suggestedEntities()
            }

        func suggestedEntities() async throws -> [HabitAppEntity] {
            // TODO: return likely AppHabitAppEntity entities here.
            // This method is optional; the default implementation returns an empty array.
            let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
            
            let habits = try! PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            return habits.map({ HabitAppEntity(habit: $0) })
        }
    }
    
}

