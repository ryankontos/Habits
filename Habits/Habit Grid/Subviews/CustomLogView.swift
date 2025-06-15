//
//  CustomLogView.swift
//  Habits
//
//  Created by Ryan on 23/11/2023.
//

import SwiftUI

struct CustomLogView: View {
    
    @State var start = Date()
    @State var end = Date()
    
    @State var habit: Habit
    
    var habits = Habit.fetchAll()
    
    
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
     
                
                Section(content: {
                    
                    DatePicker("\(habit.hasDuration ? "Start" : "Date")", selection: $start)
                        .datePickerStyle(.compact)
                    
                    if habit.hasDuration {
                        
                        DatePicker("End", selection: $end)
                            .datePickerStyle(.compact)
                        
                    }
                   
                }/*, header: {
                    
                    Emp
                    
                   /* HStack(spacing: 12) {
                        
                        Spacer()
                        
                        ZStack {
                            
                            Circle()
                                //.opacity(0.2)
                                .frame(width: 42)
                            
                            Image(systemName: habit.symbolName!)
                                .font(.habitsFont(size: 22))
                                .foregroundStyle(.white)
                                
                                
                            
                            
                            
                        }
                        .foregroundStyle(habit.color.gradient)
                        
                        Text(habit.name!)
                            .font(.habitsFont(size: 18))
                            .textCase(.none)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(UIColor.label))
                        
                        Spacer()
                        
                    }
                    .padding(.bottom, 20) */
                    
                }*/)
            }
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("Log \(habit.name!.capitalized)")
            
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction, content: {
                    Button("Cancel", action: {
                        dismiss()
                    })
                })
                ToolbarItem(placement: .confirmationAction, content: {
                    Button("Save", action: {
                        
                        let context = PersistenceController.shared.container.viewContext
                        
                        let event = Event(context: context)
                        event.startDate = start
                        if habit.hasDuration {
                            event.endDate = end
                            event.habitHasDuration = habit.hasDuration
                        }
                        
                        habit.addToEvents(event)
                        
                        try? context.save()
                        
                        dismiss()
                        
                    })
                })
            })
 
            
        }
        //.padding(.horizontal, 20)
            
    }
}

#Preview {
    
    let habit = Habit(context: PersistenceController.shared.container.viewContext)
    habit.color = .cyan
    habit.symbolName = "shower.fill"
    habit.name = "Shower"
    habit.hasDuration = false
    
    return VStack {
        
        
    }.sheet(item: .constant(habit), content: { habit in
        CustomLogView(habit: habit)
            .presentationDetents([.medium])
    })
    
}
