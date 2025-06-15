//
//  EventTotalChart.swift
//  Habits
//
//  Created by Ryan on 13/12/2023.
//

import SwiftUI
import Charts

struct EventTotalChart: View {
    
    var habit: Habit
    
    func groupAndCountEvents(events: [Event]) -> [(Date, Int)] {
        // Filter out events without a date
        let dates = events.compactMap { $0.startDate }

        guard let earliestDate = dates.min(), let latestDate = dates.max() else {
            return []
        }

        // Create a calendar and set the time zone if necessary
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current

        // Create a dictionary to hold the counts for each day
        var dailyCounts = [Date: Int]()

        // Initialize count and iterate over each day
        var totalCount = 0
        var currentDate = earliestDate

        while currentDate <= latestDate {
            let count = events.filter {
                calendar.isDate($0.startDate ?? Date.distantPast, inSameDayAs: currentDate)
            }.count

            totalCount += count
            dailyCounts[currentDate] = totalCount

            // Move to the next day
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }

        // Convert to array of tuples and sort
        return dailyCounts.map { ($0.key, $0.value) }.sorted { $0.0 < $1.0 }
    }

    
    var body: some View {
        
        Chart {
            
            ForEach(groupAndCountEvents(events: habit.eventsArray), id: \.0) { (date, count) in
                
                LineMark(
                    x: .value("Date", date),
                    y: .value("Total", count)
                )
                .foregroundStyle(habit.color)
                .interpolationMethod(.catmullRom)
               
                
            }
            
            
            
        }
        .chartPlotStyle{plotArea in
            plotArea.frame(maxWidth: .infinity, minHeight: 250.0, maxHeight: 250.0)
        }
        
        
    }
}

#Preview {
    EventTotalChart(habit: .previewHabit())
}
