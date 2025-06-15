//
//  LiveActivityLeadingView.swift
//  Habits
//
//  Created by Ryan on 14/12/2023.
//

import SwiftUI
import ActivityKit
import WidgetKit

struct LiveActivityLeadingView: View {
    
    var activity: EventActivity
    var state: EventActivity.ContentState
    
    var body: some View {
        
        
        HStack {
            
            VStack(alignment: .leading, spacing: 6) {
                HabitTitleSymbolView(habitData: activity.habitData)
                
                HStack {
                    
                    
                    Text(activity.startDate, style: .timer)
                        .foregroundStyle(Color(UIColor.label))
                        .monospacedDigit()
                        .opacity(0.8)
                        .lineLimit(1)
                        .font(.system(size: 36))
                        .fontWeight(.regular)
                        .frame(maxWidth: 500, alignment: .leading)
                }
                
            }
            
            
            
            
        }
        
        
    }
}

#Preview {
    LiveActivityLeadingView(activity: .previewActivity(), state: .init(state: .active))
}

