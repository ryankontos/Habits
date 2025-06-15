//
//  HabitDropDelegate.swift
//  Habits
//
//  Created by Ryan on 15/6/2025.
//

import Foundation
import SwiftUI
import CoreData
import UniformTypeIdentifiers

struct HabitDropDelegate: DropDelegate {
    
    // The habit view that the user is dropping onto.
    let item: Habit
    
    // The fetched results for all habits, sorted by their general order.
    let allHabits: FetchedResults<Habit>
    
    // The fetched results for habit orders within a specific group.
    let groupOrders: FetchedResults<GroupHabitOrder>
    
    // The currently selected group, if any.
    let currentGroup: HabitGroup?
    
    // The managed object context for saving changes.
    let context: NSManagedObjectContext

    /// Determines if a drop is valid.
    func validateDrop(info: DropInfo) -> Bool {
        return info.hasItemsConforming(to: [UTType.text])
    }

    /// Defines the proposal for a drop operation. We'll always propose a move.
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    /// Handles the completion of the drop.
    func performDrop(info: DropInfo) -> Bool {
        // Ensure there is an item provider for the text type.
        guard let itemProvider = info.itemProviders(for: [UTType.text]).first else { return false }

        // Load the object from the item provider. It should be the URI of the dragged Habit.
        itemProvider.loadObject(ofClass: NSString.self) { (string, error) in
            guard let draggedHabitIDString = string as? String else { return }

            // Perform the reordering on the main thread.
            DispatchQueue.main.async {
                self.reorderItems(draggedHabitIDString: draggedHabitIDString)
            }
        }
        return true
    }

    /// Reorders the habits in Core Data.
    private func reorderItems(draggedHabitIDString: String) {
        // Get the managed object ID of the dragged habit from its URI representation.
        guard let psc = context.persistentStoreCoordinator,
              let sourceHabitURL = URL(string: draggedHabitIDString),
              let sourceHabitID = psc.managedObjectID(forURIRepresentation: sourceHabitURL),
              let sourceHabit = try? context.existingObject(with: sourceHabitID) as? Habit else {
            print("Failed to find source habit from dragged ID.")
            return
        }

        // The destination habit is the one we are dropping onto.
        let destinationHabit = self.item
        
        // Don't do anything if dropping onto itself.
        guard sourceHabit.objectID != destinationHabit.objectID else { return }

        // Logic for reordering within a group
        if currentGroup != nil {
            var reorderedGroupOrders = Array(groupOrders)
            guard let sourceIndex = reorderedGroupOrders.firstIndex(where: { $0.habit == sourceHabit }),
                  let destinationIndex = reorderedGroupOrders.firstIndex(where: { $0.habit == destinationHabit }) else {
                return
            }
            
            // Reorder the array
            let movedItem = reorderedGroupOrders.remove(at: sourceIndex)
            reorderedGroupOrders.insert(movedItem, at: destinationIndex)

            // Update the 'order' attribute for each item in the group
            for (index, groupOrder) in reorderedGroupOrders.enumerated() {
                groupOrder.order = Int32(index)
            }
        } else {
            // Logic for reordering in the "All Habits" view
            var reorderedHabits = Array(allHabits)
            guard let sourceIndex = reorderedHabits.firstIndex(of: sourceHabit),
                  let destinationIndex = reorderedHabits.firstIndex(of: destinationHabit) else {
                return
            }
            
            // Reorder the array
            let movedItem = reorderedHabits.remove(at: sourceIndex)
            reorderedHabits.insert(movedItem, at: destinationIndex)
            
            // Update the 'listOrder' attribute for each habit
            for (index, habit) in reorderedHabits.enumerated() {
                habit.listOrder = Int16(index)
            }
        }

        // Save the changes to Core Data.
        do {
            try context.save()
        } catch {
            print("Error saving reordered context: \(error)")
        }
    }
}
