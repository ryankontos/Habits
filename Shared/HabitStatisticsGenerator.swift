//
//  HabitStatisticsGenerator.swift
//  Habits
//
//  Created by Ryan on 26/11/2023.
//

import Foundation



class EventStatisticsGenerator {
    private var events: [Event]

    init(events: [Event]) {
        self.events = events
    }

    func generateStatistics(forPeriod starting: Date? = nil, ending: Date? = nil) -> EventStatistics {
        let filteredEvents = filterEvents(starting: starting, ending: ending)
        let totalDuration = filteredEvents.reduce(0) { $0 + ($1.endDate?.timeIntervalSince($1.startDate!) ?? 0) }
        let averageDuration = filteredEvents.isEmpty ? 0 : totalDuration / Double(filteredEvents.count)
        let totalOccurrences = filteredEvents.count

        let sortedEvents = filteredEvents.sorted { $0.startDate! < $1.startDate! }
        let averageTimeBetween = sortedEvents.count > 1 ? zip(sortedEvents, sortedEvents.dropFirst()).reduce(0) {
            $0 + $1.1.startDate!.timeIntervalSince($1.0.endDate ?? $1.0.startDate!)
        } / Double(sortedEvents.count - 1) : 0

        return EventStatistics(totalDuration: totalDuration,
                               averageDuration: averageDuration,
                               averageTimeBetweenEvents: averageTimeBetween,
                               totalOccurrences: totalOccurrences)
    }

    private func filterEvents(starting: Date?, ending: Date?) -> [Event] {
        return events.filter {
            ($0.startDate! >= starting ?? Date.distantPast) && ($0.startDate! <= ending ?? Date.distantFuture)
        }
    }
}


struct EventStatistics {
    var totalDuration: TimeInterval
    var averageDuration: TimeInterval
    var averageTimeBetweenEvents: TimeInterval
    var totalOccurrences: Int
}
