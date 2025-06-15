//
//  HabitDisplayData.swift
//  Habits
//
//  Created by Ryan on 14/12/2023.
//

import Foundation
import SwiftUI

struct HabitDisplayData: HabitDisplayable, Codable {
    
    init(_ habit: Habit) {
        self.name = habit.name
        self.symbolName = habit.symbolName
        self.serializedColor = habit.serializedColor
    }
    
    var name: String?
    var symbolName: String?
    var serializedColor: SerializableColor?
    
}
