//
//  Habits_WidgetsLiveActivity.swift
//  Habits Widgets
//
//  Created by Ryan on 17/11/2023.
//

#if canImport(ActivityKit)
import ActivityKit
import WidgetKit
import SwiftUI



struct Habits_WidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: EventActivity.self) { context in

         
            HStack {
                
                
                LiveActivityLeadingView(activity: context.attributes, state: context.state)
               
                Spacer()
                
                LiveActivityTrailingView(activity: context.attributes, state: context.state, spacing: 15, buttonSize: 61, fontSize: 22)
                
                
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 20)
            
            
            
        } dynamicIsland: { context in
            
            let attributes = context.attributes
            
           
                
                return DynamicIsland {
                    // Expanded UI goes here.  Compose the expanded UI through
                    // various regions, like leading/trailing/center/bottom
                    
                    expandedContentBuilder(context: context)
                    
                } compactLeading: {
                    
                    
                    
                    Image(systemName: attributes.habitData.symbolName!)
                        .font(.system(size: 20))
                        .padding(.leading, 15)
                        .tint(.cyan)
                        .foregroundStyle(attributes.habitData.serializedColor!.color)
                    
                } compactTrailing: {
                    
                    
                    
                    Text(attributes.startDate, style: .timer)
                    
                        .frame(maxWidth: 60, alignment: .center)
                    
                    
                    
                    
                } minimal: {
                    Image(systemName: attributes.habitData.symbolName!)
                        .padding(.horizontal, 6)
                        .tint(attributes.habitData.serializedColor!.color)
                        .foregroundStyle(attributes.habitData.serializedColor!.color)
                }
                .widgetURL(URL(string: "http://www.apple.com"))
                .keylineTint(attributes.habitData.serializedColor!.color)
                
            
        }
    }
    
    
    
    @DynamicIslandExpandedContentBuilder
    private func expandedContentBuilder(context: ActivityViewContext<EventActivity>) -> DynamicIslandExpandedContent<some View> {
        
        let attributes = context.attributes
        
        
        
        DynamicIslandExpandedRegion(.leading) {
            
            VStack(alignment: .leading, spacing: 2) {
                
                
                Spacer()
                
                HStack(spacing: 5) {
                    Image(systemName: "\(attributes.habitData.symbolName!)")
                    Text("\(attributes.habitData.name!)")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                }
                .foregroundStyle(attributes.habitData.serializedColor!.color)
                
                
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
        }
        
        DynamicIslandExpandedRegion(.trailing) {
            
            LiveActivityTrailingView(activity: context.attributes, state: context.state, spacing: 7, buttonSize: 50, fontSize: 25)
                .padding(.top, 2)
            
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
    EventActivity.ContentState.init(state: .active)
    
}

#endif
