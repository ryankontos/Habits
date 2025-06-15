//
//  StatsCard.swift
//  Habits
//
//  Created by Ryan on 7/12/2023.
//

import SwiftUI


import SwiftUI

struct StatsCard<Content: View>: View {
    

    var habit: Habit
    var title: String
    var bodyText: String?
    var info: String?
    
    @Environment(\.colorScheme) var scheme
    
   
    let content: Content
    
    init(_ title: String, info: String? = nil, bodyText: String? = nil, habit: Habit, @ViewBuilder content: () -> Content) {
        self.habit = habit
        self.title = title
        self.bodyText = bodyText
        self.info = info
        self.content = content()
    }
    
    var body: some View {
        
        VStack(spacing: 19) {
           
            VStack(alignment: .leading, spacing: 13) {
                
                HStack(alignment: .center) {
                    
                    HStack(spacing: 3) {
                        Image(systemName: habit.symbolName!)
                        Text(title)
                            .font(.system(size: 15.5))
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(habit.color)
                    
                    Spacer()
                    
                    HStack(alignment: .center) {
                        
                        if let info {
                        
                        Text(info)
                            .foregroundStyle(.secondary)
                            .fontWeight(.regular)
                            .opacity(0.65)
                            .font(.system(size: 14))
                             
                        }
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary.opacity(0.4))
                            .font(.system(size: 13))
                            .fontWeight(.bold)
                        
                    }
                    
                }
                
                if let bodyText {
                    
                    Text(bodyText)
                        .padding(.trailing, 40)
                        .fontWeight(.semibold)
                    
                }
                
            }
            
            
            HStack {
                content
                Spacer()
                
            }
            
            
            
        }
   
        .padding(.vertical)
        .padding(.horizontal, 17)
        .background() {
         
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(scheme == .dark ? Color(UIColor.secondarySystemBackground) : Color.white)
               
            
        }
        
        
      
    }
}


#Preview {
    VStack {
        
        StatsCard("Total", habit: .previewHabit()) {
            
            HStack(alignment: .bottom, spacing: 6) {
                
                Text("12")
                    .font(.system(size: 26))
                    .fontWeight(.medium)
                
                Text("logs")
                    .foregroundStyle(.secondary)
                    .fontWeight(.medium)
                
                
            }
            
        }
        
    }
    .frame(height: 200)
}


