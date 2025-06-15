//
//  HabitTitleSymbolView.swift
//  Habits
//
//  Created by Ryan on 14/12/2023.
//

import SwiftUI

struct HabitTitleSymbolView: View {
    
    var habitData: HabitDisplayable
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "\(habitData.symbolName!)")
            Text("\(habitData.name!)")
                .font(.system(size: 18))
                .fontWeight(.semibold)
        }
        .foregroundStyle(habitData.serializedColor!.color)
        
    }
}

#Preview {
    HabitTitleSymbolView(habitData: Habit.previewHabit().displayData())
}
