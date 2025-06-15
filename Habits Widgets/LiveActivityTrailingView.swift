//
//  LiveActivityTrailingView.swift
//  Habits
//
//  Created by Ryan on 14/12/2023.
//

import SwiftUI
import WidgetKit
import ActivityKit

struct LiveActivityTrailingView: View {
    
    var activity: EventActivity
    var state: EventActivity.ContentState
    
    var spacing: CGFloat
    var buttonSize: CGFloat
    var fontSize: CGFloat
    
    var body: some View {
        
        if state.state == .active {
            
            HStack(spacing: spacing) {
                
                
                CircleIconButtonView(color: .gray, iconName: "pause", buttonSize: buttonSize, fontSize: fontSize)
                
            }
            
        } else if state.state == .paused {
            
            HStack(spacing: spacing) {
                
                CircleIconButtonView(color: activity.habitData.serializedColor!.color, iconName: "play.fill", buttonSize: buttonSize, fontSize: fontSize)
                
                CircleIconButtonView(color: .red, iconName: "stop.fill", buttonSize: buttonSize, fontSize: fontSize)
                
            }
            
        } else {
            
            HStack {
                
                Spacer()
                
                CircleIconButtonView(color: .red, iconName: "arrow.uturn.backward", buttonSize: buttonSize, fontSize: fontSize)
                
            }
            
        }
        
    }
}

#Preview {
    LiveActivityTrailingView(activity: .previewActivity(), state: .init(state: .active), spacing: 10, buttonSize: 70, fontSize: 40)
}
