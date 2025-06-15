//
//  HabitReorderView.swift
//  Habits
//
//  Created by Ryan on 25/11/2023.
//

import SwiftUI

struct HabitReorderView: View {
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.listOrder)]) var habits: FetchedResults<Habit>
    @Environment(\.managedObjectContext) var context
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.editMode) private var editing

    @State var editingHabit: Habit?
    
    @State private var presentedHabits: [Habit] = []
    
    var body: some View {
        NavigationStack(path: $presentedHabits) {
            
            List {
                
                Section(content: {
                    
                    ForEach(habits) { habit in
                        
                      
                            HStack(spacing: 10) {
                                
                                Image(systemName: habit.symbolName!)
                                    .foregroundStyle(habit.color)
                                    .frame(width: 30)
                                    .font(.habitsFont(size: 19))
                                
                                Text(habit.name!)
                                
                            }
                    
                    }
                    .onMove { fromOffsets, toOffset in
                        
                        
                        // Assuming 'habits' is your fetched results array.
                        var reorderedHabits = habits.map { $0 }
                        
                        // Move the habits within the array to reflect the UI change.
                        reorderedHabits.move(fromOffsets: fromOffsets, toOffset: toOffset)

                        // Update the listOrder property of each habit.
                        for (index, habit) in reorderedHabits.enumerated() {
                            habit.listOrder = Int16(index)
                        }

                        // Save the context.
                        
                        DispatchQueue.main.async {
                            
                            do {
                                try context.save()
                            } catch {
                                // Handle the error appropriately.
                                print("Error saving context: \(error)")
                            }
                            
                        }
                    }
                    
                })
              
            }
            .toolbarTitleDisplayMode(.inline)
         
            .sheet(item: $editingHabit) { habit in
                EditHabitView(habit, group: nil)
            }
            .environment(\.editMode, .constant(.active))
            
            .navigationTitle("Rearrange Habits")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button("Done", action: {
                        self.dismiss()
                    })
                    .fontWeight(.bold)
                })
            })
            .navigationDestination(for: Habit.self) { habit in
                
                EditHabitView(habit, group: nil)
                
            }
            
        }
       
    }
}

#Preview {
    HabitReorderView()
}
