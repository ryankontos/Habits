//
//  ActiveHabitEventView.swift
//  Habits
//
//  Created by Ryan on 16/11/2023.
//

import SwiftUI

struct ActiveHabitEventView: View {
    
    @ObservedObject var habit: Habit
    @ObservedObject var event: Event
    
    @Environment(\.managedObjectContext) var context
    
    @State var stopDate: Date?
    
    static var start = Date()
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(Color.secondary.opacity(0.2))
            .frame(height: 100)
            .overlay {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(spacing: 5) {
                            Image(systemName: "\(habit.symbolName!)")
                            Text("\(habit.name!)")
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(habit.color)
                        
                        if let stopDate = stopDate {
                          
                            Text(event.startDate?.msTimerString(at: stopDate) ?? "")
                                .foregroundStyle(Color(UIColor.label))
                                .monospacedDigit()
                                .opacity(0.8)
                                .font(.system(size: 29))
                            
                        } else {
                            TimelineView(.periodic(from: ActiveHabitEventView.start, by: 0.04)) { context in
                                
                                Text(event.startDate?.msTimerString(at: context.date) ?? "")
                                    .foregroundStyle(Color(UIColor.label))
                                    .monospacedDigit()
                                    .opacity(0.8)
                                    .font(.system(size: 29))
                            }
                        }
                        
                     
                        
                    }
                    Spacer()
                    
                    // spacing 20, size 55, text 20
                    
                    TimedHabitActionButtons(event: event,
                                            buttonSpacing: 20, buttonSize: 55, buttonFontSize: 20)
                    
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                
            }
    }
    

}

/*
#Preview {
    
    let habit = Habit(name: "Shower", color: .cyan, iconName: "shower.fill", listOrder: 0)
    
    let event = Event(habit: habit, notes: "", date: Date())
    
    return ActiveHabitEventView(habit: habit, event: event)
}
*/
