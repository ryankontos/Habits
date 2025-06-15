//
//  DeleteHabitAlertViewModifier.swift
//  Habits
//
//  Created by Ryan on 25/11/2023.
//

import SwiftUI

struct DeleteHabitAlertViewModifier: ViewModifier {
    
    
    @Environment(\.managedObjectContext) var context
    @Binding var showAlert: Bool
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var habit: Habit
    var dismissAfterDelete: Bool = true
    
    func body(content: Content) -> some View {
        content
            .alert("Delete \(habit.name ?? "Nil Habit")?", isPresented: $showAlert, presenting: habit, actions: { habit in
                
                Button("Cancel", role: .cancel, action: {
                    
                })
                
                Button("Delete", role: .destructive, action: {
                    let url = habit.objectID.uriRepresentation()
                    
                    Task {
                        
                        #if canImport(ActivityKit)
                        
                        await ActivityManager.endEventsWithHabit(url: url)
                        
                        #endif
                    }
                   
                   
                    
                    DispatchQueue.main.async {
                        habit.willDelete = true
                        context.delete(habit)
                        try? context.save()
                    }
                    
                    if dismissAfterDelete { dismiss() }
                })
                
            }, message: { habit in
                
                    Text(generateMessage())
                
            })
            
    }
    
    func generateMessage() -> String {
        
        if let events = habit.events, events.count > 0 {
            
            let count = events.count
            
            return "Deleting it will also permanently delete \(count) associated event\(count == 1 ? "" : "s")."
            
        } else {
            return ""
        }
        
        
    }
    
}

extension View {
    @ViewBuilder func deleteHabitAlert(showAlert: Binding<Bool>, habit: Habit?, dismissAfterDelete: Bool = true) -> some View {
        
        if let habit = habit {
            self.modifier(DeleteHabitAlertViewModifier(showAlert: showAlert, habit: habit, dismissAfterDelete: dismissAfterDelete))
        } else {
            self
        }
        
       
        
    }
}
