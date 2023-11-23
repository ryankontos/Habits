//
//  AWHabitListItemView.swift
//  Habits Watch Watch App
//
//  Created by Ryan on 22/11/2023.
//

import SwiftUI

struct WatchHabitListItemView: View {
    
    var habit: Habit
    
    var body: some View {
        
        HStack {
            HStack(spacing: 5) {
                
                Circle()
                    .foregroundColor(habit.color)
                    .frame(width: 35, height: 35)
                    .overlay {
                        Image(systemName: habit.symbolName!)
                    }
                
                VStack(alignment: .leading) {
                    
                    Text(habit.name!)
                    Text("10 minutes ago")
                        .foregroundColor(.secondary)
                    
                }
                
            }
            
          
            Spacer()
            
        }
        .listItemTint(habit.color.opacity(0.5))
        .padding(.vertical, 5)
        
    }
    
    
}

/*struct WatchHabitListItemView_Previews: PreviewProvider {
    static var previews: some View {
        WatchHabitListItemView(habit: .init(name: "Ibuprofen", color: Color.blue, iconName: "pill.fill"))
    }
}*/

extension Date {
    func timeAgoString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false

        return formatter.string(from: self, to: Date()) ?? "Just now"
    }
}
