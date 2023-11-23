//
//  HabitList.swift
//  Habits Watch Watch App
//
//  Created by Ryan on 22/11/2023.
//

import SwiftUI

struct HabitList: View {
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.listOrder)], animation: .default) var habits: FetchedResults<Habit>
    
    var body: some View {
        NavigationStack {
                
                    TimelineView(.periodic(from: Date(), by: 1)) { context in
                        
                        List {
                            
                            
                            
                            ForEach(habits) { habit in
                                
                                Button(action: {
                                   
                                }, label: {
                                    WatchHabitListItemView(habit: habit)
                                })
                                .listItemTint(habit.color.opacity(0.6))
                                
                                
                            }
                            
                        }
                        .navigationTitle("Habits")
                        
                    }
                    
                }
            
    }
}

#Preview {
    HabitList()
}
