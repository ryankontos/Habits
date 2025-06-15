//
//  ActivityManager.swift
//  Habits
//
//  Created by Ryan on 21/11/2023.
//


import Foundation
#if canImport(ActivityKit)
import ActivityKit


class ActivityManager {
    
    
    
    static func updateActivities() {
        
        DispatchQueue.main.async {
            let activities = Activity<EventActivity>.activities
            
            for activity in activities {
                guard let event = Event.getEventForURI(uri: activity.attributes.eventID) else {
                    endActivity(activity)
                    continue
                }

                if event.endDate != nil || !event.habitHasDuration || !(event.habit?.hasDuration ?? true) || event.isCancelled {
                    endActivity(activity)
                }
            }
        }
    }
   
    static func updateActivityWith(url: URL, using contentState: EventActivity.ContentState) async {
        
        let activities = findActivities(with: url)
        
        for activity in activities {
            
            await activity.update(.init(state: contentState, staleDate: nil))
        }
        
    }
    
    static func endEventsWithHabit(url: URL) async {
        
        let activities = findActivities(withHabit: url)
        
        for activity in activities {
            await activity.end(.init(state: .init(state: .destroyed), staleDate: nil), dismissalPolicy: .immediate)
        }
        
        
    }
    
    static func endEventWith(url: URL, withState: EventActivity.StateOption = .destroyed) async {
        
        let activities = findActivities(with: url)
        
        for activity in activities {
            await activity.end(.init(state: .init(state: withState), staleDate: nil), dismissalPolicy: withState == .destroyed ? .immediate : .default)
        }
        
    }
    
    static func findActivities(with url: URL) -> [Activity<EventActivity>] {
        
        return Activity<EventActivity>.activities.filter({ $0.attributes.eventID == url })
    }
 
    
    static func findActivities(withHabit url: URL) -> [Activity<EventActivity>] {
        
        return Activity<EventActivity>.activities.filter({ $0.attributes.habitID == url })
    }
 
    

    private static func endActivity(_ activity: Activity<EventActivity>) {
        Task {
            await activity.end(.init(state: .init(state: .destroyed), staleDate: nil), dismissalPolicy: .immediate)
        }
    }
 
    
    
}

#endif
