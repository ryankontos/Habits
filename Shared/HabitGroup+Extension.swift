//
//  HabitGroup+Extension.swift
//  Habits
//
//  Created by Ryan on 27/11/2023.
//

import CoreData

extension HabitGroup {
    
    private func nextOrderValue() -> Int32 {
        let fetchRequest: NSFetchRequest<GroupHabitOrder> = GroupHabitOrder.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "habitGroup == %@", self)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: false)]
        fetchRequest.fetchLimit = 1

        do {
            let lastOrder = try PersistenceController.shared.container.viewContext.fetch(fetchRequest).first
            return (lastOrder?.order ?? 0) + 1
        } catch {
            print("Error fetching last order: \(error)")
            return 0
        }
    }
    
    func addHabit(habit: Habit) {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let newOrder = GroupHabitOrder(context: viewContext)
        newOrder.habit = habit
        newOrder.habitGroup = self
        newOrder.order = nextOrderValue()
        
        viewContext.insert(newOrder)
        self.addToHabits(habit)
        
        try? viewContext.save()
    }
    
}
