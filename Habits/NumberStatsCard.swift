//
//  NumberStatsCard.swift
//  Habits
//
//  Created by Ryan on 7/12/2023.
//

import SwiftUI

struct NumberStatsCard: View {
    
    var habit: Habit
    var title: String
    var info: String?
    var number: String
    var unit: String?
    
    
    init(_ title: String, info: String? = nil, habit: Habit, number: String, unit: String? = nil) {
        self.habit = habit
        self.title = title
        self.info = info
        self.number = number
        self.unit = unit
    }
    
    var body: some View {
        
        StatsCard(title, info: info, habit: habit) {
            
            HStack(alignment: .bottom, spacing: 6) {
                
                Text(number)
                    .font(.system(size: 26))
                    .fontWeight(.medium)
                
                Text(unit ?? "")
                    .foregroundStyle(.secondary)
                    .fontWeight(.medium)
                
            }
            
        }
        
    }
    
}


#Preview {
    NumberStatsCard("Total", habit: .previewHabit(), number: "100")
}
