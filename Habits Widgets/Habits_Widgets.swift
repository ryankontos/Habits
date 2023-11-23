//
//  Habits_Widgets.swift
//  Habits Widgets
//
//  Created by Ryan on 17/11/2023.
//

import WidgetKit
import SwiftUI
import AppIntents

typealias ConfigurationAppIntent = HabitsWidgetIntent

struct Provider: AppIntentTimelineProvider {
    
     func recommendations() -> [AppIntentRecommendation<HabitsWidgetIntent>] {
        
         let habits = Habit.fetchAll()
         
         var reccomendations = [AppIntentRecommendation<HabitsWidgetIntent>]()
         
         for habit in habits {
             let entity = HabitAppEntity(habit: habit)
             
             let intent = HabitsWidgetIntent()
             intent.habits = [entity]
             intent.showActiveTimer = false
             
             
             reccomendations.append(.init(intent: intent, description: habit.name!))
         }
         
         
        return reccomendations
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let habits = [Habit]()
    
}


#if os(iOS)

struct Habits_Widgets: Widget {
    let kind: String = "Habits_Widgets"

    @Environment(\.widgetFamily) var family
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
           
            MultiHabitButtonWidgetView(entry: entry)
            .containerBackground(.ultraThinMaterial, for: .widget)
       
        }
        .contentMarginsDisabledIfAvailable()
    }
}


#Preview(as: .systemSmall) {
    Habits_Widgets()
} timeline: {
    SimpleEntry(date: Date(), configuration: .init())
}

#endif

#if os(watchOS)

struct Habits_Watch_Widgets: Widget {
    let kind: String = "Habits_Watch_Widgets"

    @Environment(\.widgetFamily) var family
    
    private static let deeplinkURL = URL(string: "widget-deeplink://")!
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
           
            
            Group {
                
                if let id = entry.configuration.habits?.first?.url, let habit = Habit.getHabitForURI(uri: id)  {
                    Image(systemName: habit.symbolName!)
                        
                        .foregroundStyle(habit.color)
                } else {
                    Image(systemName: "questionmark")
                        .foregroundStyle(.red)
                }
                
            }
            .font(.system(size: 20))
            
            .userActivity(/*@START_MENU_TOKEN@*/"Activity"/*@END_MENU_TOKEN@*/, element: /*@START_MENU_TOKEN@*/"Element"/*@END_MENU_TOKEN@*/, { element, activity in
                
            })
            .widgetURL(Self.deeplinkURL)
            
            
            .containerBackground(.ultraThinMaterial, for: .widget)
       
        }
        .supportedFamilies([.accessoryCircular])
        .contentMarginsDisabledIfAvailable()
    }
}


#endif


extension WidgetConfiguration
{
    func contentMarginsDisabledIfAvailable() -> some WidgetConfiguration
    {
        if #available(iOSApplicationExtension 17.0, *)
        {
            return self.contentMarginsDisabled()
        }
        else
        {
            return self
        }
    }
}
