//
//  LiveActivityCancelPromptView.swift
//  Habits
//
//  Created by Ryan on 14/12/2023.
//

import SwiftUI
import WidgetKit

struct LiveActivityCancelPromptView: View {
    
    var activity: EventActivity
    
    var body: some View {
        
        VStack {
            
            Text("Cancel?")
                .foregroundStyle(.secondary)
                .lineLimit(1)
            
            HStack {
                
                Button(role:.destructive, intent: CompleteTimedEventIntent(type: .cancel, id: activity.habitID), label: {
                    Text("Yes")
                        .frame(width: 50)
                })
                
                
                Button(intent: CompleteTimedEventIntent(type: .undoCancel, id: activity.eventID), label: {
                    Text("No")
                        .frame(width: 50)
                })
                
                
            }
            
        }
        
    }
}

#Preview {
    LiveActivityCancelPromptView(activity: .previewActivity())
}
