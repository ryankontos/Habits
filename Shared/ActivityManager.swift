//
//  ActivityManager.swift
//  Habits
//
//  Created by Ryan on 21/11/2023.
//

import Foundation
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
    
    static func endEventWith(url: URL) async {
        
        let activities = findActivities(with: url)
        
        for activity in activities {
            await activity.end(.init(state: .init(ended: true), staleDate: nil), dismissalPolicy: .immediate)
        }
        
    }
    
    static func findActivities(with url: URL) -> [Activity<EventActivity>] {
        
        return Activity<EventActivity>.activities.filter({ $0.attributes.eventID == url })
    }
 
    

    private static func endActivity(_ activity: Activity<EventActivity>) {
        Task {
            await activity.end(.init(state: .init(ended: true), staleDate: nil), dismissalPolicy: .immediate)
        }
    }
 
    
    
}
