//
//  Habits_WidgetsLiveActivity.swift
//  Habits Widgets
//
//  Created by Ryan on 17/11/2023.
//

import ActivityKit
import WidgetKit
import SwiftUI


struct Habits_WidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: EventActivity.self) { context in
            

            HStack {
                
                
                
                let attributes = context.attributes
                
                HStack {
                    
                    
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 5) {
                            Image(systemName: "\(attributes.symbolName)")
                            Text("\(attributes.habitName)")
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(attributes.color)
                        
                        
                        HStack {
                            
                            
                            Text(attributes.startDate, style: .timer)
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
                
                Spacer()
                
                if context.state.userWantsToCancel {
                    getConfirmCancelView(id: attributes.eventID)
                } else {
                    TimedHabitActionButtons(eventID: attributes.eventID, color: attributes.color, buttonSpacing: 10, buttonSize: 50, buttonFontSize: 20)
                }
                
                
                
                
                
                
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 20)
            .activityBackgroundTint(Color.secondary)
            
            
            //.activitySystemActionForegroundColor(context.attributes.color.color)
            
        } dynamicIsland: { context in
            
            let attributes = context.attributes
            
           
                
                return DynamicIsland {
                    // Expanded UI goes here.  Compose the expanded UI through
                    // various regions, like leading/trailing/center/bottom
                    
                    expandedContentBuilder(context: context)
                    
                } compactLeading: {
                    
                    
                    
                    Image(systemName: attributes.symbolName)
                        .font(.system(size: 20))
                        .padding(.leading, 15)
                        .tint(.cyan)
                        .foregroundStyle(attributes.color)
                    
                } compactTrailing: {
                    
                    
                    
                    Text(attributes.startDate, style: .timer)
                    
                        .frame(maxWidth: 60, alignment: .center)
                    
                    
                    
                    
                } minimal: {
                    Image(systemName: attributes.symbolName)
                        .padding(.horizontal, 6)
                        .tint(.cyan)
                        .foregroundStyle(attributes.color)
                }
                .widgetURL(URL(string: "http://www.apple.com"))
                .keylineTint(attributes.color)
                
            
        }
    }
    
    
    
    @DynamicIslandExpandedContentBuilder
    private func expandedContentBuilder(context: ActivityViewContext<EventActivity>) -> DynamicIslandExpandedContent<some View> {
        
        let attributes = context.attributes
        
        
        
        DynamicIslandExpandedRegion(.leading) {
            
            VStack(alignment: .leading, spacing: 2) {
                
                
                Spacer()
                
                HStack(spacing: 5) {
                    Image(systemName: "\(attributes.symbolName)")
                    Text("\(attributes.habitName)")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                }
                .foregroundStyle(attributes.color)
                
                
                HStack {
                    
                    Text(attributes.startDate, style: .timer)
                        .foregroundStyle(Color(UIColor.label))
                        .monospacedDigit()
                        .opacity(0.8)
                        .font(.system(size: 33))
                        .fontWeight(.regular)
                        .frame(maxWidth: 100, alignment: .leading)
                }
                
                Spacer()
                
            }
            .padding(.leading, 7)
            
            
            
        }
        DynamicIslandExpandedRegion(.trailing) {
            
            VStack {
                
                Spacer()
                
                // spac 10, wid, 52, te, 20
                
                if context.state.userWantsToCancel {
                    getConfirmCancelView(id: attributes.eventID)
                } else {
                    TimedHabitActionButtons(eventID: attributes.eventID, color: attributes.color, buttonSpacing: 10, buttonSize: 50, buttonFontSize: 20)
                }
                
                
                
                Spacer()
                
            }
            .padding(.trailing, 7)
            
            
        }
        
    }
    
 
    
    func getConfirmCancelView(id: URL) -> some View {
        
        VStack {
            
            Text("Cancel?")
                .foregroundStyle(.secondary)
                .lineLimit(1)
            
            HStack {
                
                Button(role:.destructive, intent: CompleteTimedEventIntent(type: .cancel, id: id), label: {
                    Text("Yes")
                        .frame(width: 50)
                })
                
                
                Button(intent: CompleteTimedEventIntent(type: .undoCancel, id: id), label: {
                    Text("No")
                        .frame(width: 50)
                })
                
                
            }
            
        }
        
        
    }
  
    
}



extension EventActivity {
    fileprivate static var preview: EventActivity {
        
        
        let previewContext = PersistenceController.preview.container.viewContext
        
        let habit = Habit(context: previewContext)
        habit.name = "Shower"
        habit.color = .blue
        habit.symbolName = "shower.fill"
        habit.hasDuration = true
        
        let event = Event(context: previewContext)
        event.habit = habit
        event.startDate = Date()
        event.endDate = nil
        event.habitHasDuration = true
        
        try! previewContext.save()
        
        return EventActivity(event: event, preview: true)
    }
}


#Preview("Notification", as: .content, using: EventActivity.preview) {
   Habits_WidgetsLiveActivity()
} contentStates: {
    EventActivity.ContentState.init(ended: false)
    
}

