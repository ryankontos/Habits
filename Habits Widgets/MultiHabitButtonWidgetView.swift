//
//  MultiHabitButtonWidgetView.swift
//  Habits WidgetsExtension
//
//  Created by Ryan on 22/11/2023.
//

import SwiftUI
import WidgetKit

struct MultiHabitButtonWidgetView: View {

    var entry: Provider.Entry
    
    
    let habits = Habit.fetchAll()
    
    @Environment(\.widgetFamily) var family
    
    var columns: [GridItem] {
        
        let item = GridItem(.flexible(minimum: 90, maximum: 1000), spacing: spacingConfiguration.columnSpacing)
        
        var array = [GridItem]()
        
        array.append(contentsOf: repeatElement(item, count: 2))
        
        if family == .systemExtraLarge {
            array.append(item)
        }
        
        return array
        
    }
    
    var spacingConfiguration: SpacingConfiguration {
        switch family {

        case .systemMedium:
            return SpacingConfiguration(rowSpacing: 7, columnSpacing: 7, buttonHeight: 68)
        case .systemLarge:
            return SpacingConfiguration(rowSpacing: 7, columnSpacing: 7, buttonHeight: 62.2)
        case .systemExtraLarge:
            return SpacingConfiguration(rowSpacing: 6, columnSpacing: 6, buttonHeight: 69)
        default:
            return SpacingConfiguration(rowSpacing: 6, columnSpacing: 6, buttonHeight: 69)
        }
    }
    
    var habitLimit: Int {
        switch family {

        case .systemMedium:
            return 4
        case .systemLarge:
            return 10
        case .systemExtraLarge:
            return 15
        default:
            return 4
        }
    }
    
    struct SpacingConfiguration {
        var rowSpacing: CGFloat
        var columnSpacing: CGFloat
        var buttonHeight: CGFloat
    }

    var body: some View {
        VStack {
            
        
            
            LazyVGrid(columns: columns, spacing: spacingConfiguration.rowSpacing) {
                
                ForEach(habits.prefix(habitLimit), id: \.self) { habit in
                    
                    RoundedRectangle(cornerRadius: 17)
                        .foregroundStyle(habit.color.gradient)
                        .frame(height: spacingConfiguration.buttonHeight)
                        .overlay {
                            
                            VStack(alignment: .leading) {
                                
                                HStack {
                                    Image(systemName: habit.symbolName!)
                                        .font(.system(size: 14))
                                        .foregroundStyle(.white)
                                    Spacer()
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .leading) {
                                    Text(habit.name!)
                                        .lineLimit(1)
                                        .fontWeight(.semibold)
                                        .font(.system(size: 12))
                                        .foregroundStyle(.white)
                                    Text("1 hour ago")
                                        .lineLimit(1)
                                        .fontWeight(.regular)
                                        .font(.system(size: 11))
                                        .foregroundStyle(.white)
                                }
                                .shadow(radius: 11)
                                
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 9)
                            
                        }
                    
                        
                    
                }
                
            }
            .padding(.horizontal, spacingConfiguration.columnSpacing)
           
            
            
        }
        
    }
}



#Preview(as: .systemSmall) {
    Habits_Widgets()
} timeline: {
    SimpleEntry(date: Date(), configuration: .init())
}

