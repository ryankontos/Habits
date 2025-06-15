//
//  FullScreenActiveEventView.swift
//  Habits
//
//  Created by Ryan on 18/11/2023.
//

import SwiftUI
import CoreData

import os.log

struct FullScreenActiveEventView: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @State private var contextChangesObserver: Any?
    
    @ObservedObject var event: Event
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
    
        Group {
            
            if let habit = event.habit {
                
                VStack(spacing: 90) {
                    
                    Spacer()
                    
                    VStack(spacing: 15) {
                        
                        HStack(spacing: 13) {
                            
                            Image(systemName: "\(habit.symbolName!)")
                                .font(.habitsFont(size: 30))
                            Text("\(event.habit?.name ?? "")")
                                .font(.habitsFont(size: 25))
                                .fontWeight(.semibold)
                            
                        }
                        .foregroundStyle(event.habit?.color ?? .primary)
                        
                        TimelineView(.periodic(from: Date(), by: 0.04)) { i in
                            
                            Text(event.startDate?.msTimerString(at: i.date) ?? "")
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .font(.habitsFont(size: 90))
                                .fontWeight(.thin)
                                .monospacedDigit()
                            
                        }
                        
                        
                    }
                    
                    
                    VStack {
                        
                        // spacing 70, size 90, font size, 30
                        
                        TimedHabitActionButtons(event: event, buttonSpacing: 70, buttonSize: 90, buttonFontSize: 30, actionMode: .action({
                            
                            self.dismiss()
                            
                        }))
                        
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 30)
               /* .safeAreaInset(edge: .bottom, content: {
                    
                    VStack {
                        Text("Average: 00:00")
                        Text("Min: 00:00")
                        Text("Max: 00:00")
                    }
                    .padding(.bottom, 20)
                    
                }) */
                
                .onAppear() {
                    
                    #if canImport(ActivityKit)
                    
                    ActivityManager.updateActivities()
                    
                    #endif
                }
                
                
                .onChange(of: event) {
                    if event.managedObjectContext == nil {
                        dismiss()
                    }
                }
                
                
            } else {
                EmptyView()
                
            }
            
            
        }
        
        
        .onChange(of: event.habitHasDuration, initial: true) {  (old, new) in
            if event.habitHasDuration == false {
                dismiss()
            }
        }
        
      
            
    }
    


 
}


#Preview {
    
    let previewContext = PersistenceController.preview.container.viewContext
    
    let habit = Habit(context: previewContext)
    habit.name = "Test"
    habit.color = .green
    habit.symbolName = "sparkles"
    habit.hasDuration = true
    
    let event = Event(context: previewContext)
    event.habit = habit
    event.startDate = Date()
    event.endDate = nil
    event.habitHasDuration = true
    
    return FullScreenActiveEventView(event: event)
}

