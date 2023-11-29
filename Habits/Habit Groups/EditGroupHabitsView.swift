//
//  EditGroupHabitsView.swift
//  Habits
//
//  Created by Ryan on 28/11/2023.
//

import SwiftUI
import CoreData

/// A form that allows users to add habits to a group and rearrange them.
struct EditGroupHabitsView: View {
    
    var group: HabitGroup
    
    @Environment(\.dismiss) var dismiss
    
    @State var inGroupHabits = [Habit]()
    @State var outGroupHabits = [Habit]()
    
    @State var editMode: EditMode = .inactive
    @State var selection = Set<UUID>()
    
    @State private var tempHabitStates: [Habit: Bool] = [:]
    
    var body: some View {
        
        NavigationStack {
            
            List {
                
                Section("Included") {
                    
                    ForEach(inGroupHabits) { habit in
                        
                        if self.editMode == .inactive {
                            
                            
                            getToggleView(for: habit)
                            
                        } else {
                            
                            getRowView(for: habit)
                            
                        }
                        
                        
                        
                        
                    }.onMove(perform: moveHabit)
                    
                }
                
                if self.editMode == .inactive {
                    
                    Section("Not Included") {
                        
                        ForEach(outGroupHabits) { habit in
                            
                            if self.editMode == .inactive {
                                
                                
                                getToggleView(for: habit)
                                
                            } else {
                                
                                getRowView(for: habit)
                                
                            }
                            
                            
                        }
                        
                    }
                    
                }
                
                
            }
            .navigationTitle(group.name ?? "Manage Habits")
            .toolbarTitleDisplayMode(.inline)
            .environment(\.editMode, self.$editMode)
            .toolbar { // Assumes embedding this view in a NavigationView.
                ToolbarItem(placement: .topBarTrailing) {
                    editButton
                        
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", action: {
                        dismiss()
                    })
                        .fontWeight(.semibold)
                }
            }
            
            
            
        }
        .onAppear {
            DispatchQueue.main.async {
                self.updateHabits(for: group)
            }
        }

    }
    
    func getRowView(for habit: Habit) -> some View {
        
        HStack {
            
            Image(systemName: habit.symbolName!)
                .foregroundStyle(habit.color)
            Text(habit.name!)
            
            Spacer()
            
            
        }
        
        
    }
    
    func getToggleView(for habit: Habit) -> some View {
        
        Toggle(isOn: Binding(
            get: { self.tempHabitStates[habit] ?? self.isHabitInGroup(habit) },
            set: { isOn in
                self.tempHabitStates[habit] = isOn
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.checkHabitsToToggle(for: habit)
                }
                
                   
                
            }
        )) {
            getRowView(for: habit)
        }
        .id(habit)
        
    }
    
    private var editButton: some View {
          Button(action: {
              
              withAnimation {
                  
                  self.editMode.toggle()
                  self.selection = Set<UUID>()
                  
              }
          }) {
              Text(self.editMode.title)
          }
      }

    
    private func moveHabit(from source: IndexSet, to destination: Int) {
            let viewContext = PersistenceController.shared.container.viewContext

            // Adjust the order of the habits in the inGroupHabits array
            inGroupHabits.move(fromOffsets: source, toOffset: destination)

            // Update the order of each habit in the inGroupHabits array
            for (index, habit) in inGroupHabits.enumerated() {
                let fetchRequest: NSFetchRequest<GroupHabitOrder> = GroupHabitOrder.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "habit == %@ AND habitGroup == %@", habit, group)

                do {
                    if let order = try viewContext.fetch(fetchRequest).first {
                        order.order = Int32(index)
                    }
                } catch {
                    print("Error updating order: \(error)")
                }
            }

            do {
                try viewContext.save()
               
                                withAnimation {
                                    updateHabits(for: group)
                                }
                            
            } catch {
                print("Error saving context: \(error)")
            }
        }

    private func isHabitInGroup(_ habit: Habit) -> Bool {
        return group.habits!.contains(habit)
    }
  
    func updateHabits(for group: HabitGroup) {
        
        self.inGroupHabits = EditGroupHabitsView.fetchHabitsInGroup(group: group)
        self.outGroupHabits = EditGroupHabitsView.fetchHabitsNotInGroup(group: group)
       
        
    }
    
    private static func fetchHabitsInGroup(group: HabitGroup) -> [Habit] {
        let context = PersistenceController.shared.container.viewContext

        let request: NSFetchRequest<GroupHabitOrder> = GroupHabitOrder.fetchRequest()
        request.predicate = NSPredicate(format: "habitGroup == %@", group)

        do {
            let groupHabitOrders = try context.fetch(request)
            let orderedHabits = groupHabitOrders.sorted { $0.order < $1.order }.compactMap { $0.habit }

            // Assuming 'habits' is the NSSet of Habit objects in HabitGroup
            let allHabits = group.habits as? Set<Habit> ?? []
            let unorderedHabits = allHabits.subtracting(orderedHabits)

            
            return orderedHabits + unorderedHabits
        } catch {
            print("Error fetching data: \(error)")
            fatalError()
        }
    }
    
    private static func fetchHabitsNotInGroup(group: HabitGroup) -> [Habit] {
        print("Group habits: \(group.habits!)")
        
      
        
        let context = PersistenceController.shared.container.viewContext

        let request = Habit.fetchRequest()
        
        // Create a predicate to fetch habits not in the specified group
       request.predicate = NSPredicate(format: "NOT (SELF IN %@)", group.habits!)

        do {
            let habitsNotInGroup = try context.fetch(request)
            print("Habits: \(habitsNotInGroup.count)")
            return habitsNotInGroup
        } catch {
            print("Error fetching habits: \(error)")
            return []
        }
    }
    
    func checkHabitsToToggle(for hab: Habit) {
        
        let temp = tempHabitStates
        
        for item in temp {
            
            if item.key != hab {
                continue
            }
            
            withAnimation {
                toggleHabit(item.key, isInGroup: item.value)
            }
            
           
            
        }
        
    }

    
    private func toggleHabit(_ habit: Habit, isInGroup: Bool) {
        
            
            let viewContext = PersistenceController.shared.container.viewContext
            
            if isInGroup {
                // Add habit to group and create a GroupHabitOrder
               //
                
                group.addHabit(habit: habit)
                
            } else {
                // Remove habit from group and delete the GroupHabitOrder
                let fetchRequest: NSFetchRequest<GroupHabitOrder> = GroupHabitOrder.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "habit == %@ AND habitGroup == %@", habit, group)
                
                do {
                    let orders = try viewContext.fetch(fetchRequest)
                    orders.forEach(viewContext.delete)
                    group.removeFromHabits(habit)
                } catch {
                    print("Error fetching GroupHabitOrder for deletion: \(error)")
                }
            }
            
            do {
                try viewContext.save()
                
                
                    
                    withAnimation {
                        updateHabits(for: group)
                        tempHabitStates.removeAll()
                    }
                    
                
                
                
            } catch {
                print("Error saving context: \(error)")
            }
            
        
    }
    
}

extension EditMode {
    var title: String {
        self == .active ? "Done" : "Rearrange"
    }
    
    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}
