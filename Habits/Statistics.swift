//
//  Statistics.swift
//  Habits
//
//  Created by Ryan on 10/12/2023.
//

import Foundation

struct Statistics {
    var durationStatistics: [Statistic]
    var intervalStatistics: [Statistic]
    var otherStatistics: [Statistic]
}

struct Statistic: Identifiable {
    
    var id: String {
        return title + value
    }
    
    let title: String
    let value: String
}

func calculateStatistics(for events: [Event]) -> Statistics {
    let durations = events.compactMap { $0.endDate?.timeIntervalSince($0.startDate!) }
    let intervals = zip(events, events.dropFirst()).map { $1.startDate!.timeIntervalSince($0.endDate ?? $0.startDate!) }
    let countMissingEndDates = events.filter { $0.endDate == nil }.count

    // Calculate statistics for durations
    let durationStats = calculateTimeStats(from: durations)
    
    // Calculate statistics for intervals
    let intervalStats = calculateTimeStats(from: intervals)

    var durationStatisticsArray: [Statistic] = []
    var intervalStatisticsArray: [Statistic] = []
    var otherStatisticsArray: [Statistic] = []
    

    // Duration Statistics
    durationStatisticsArray.append(contentsOf: [
        Statistic(title: "Mean Duration", value: formatTimeInterval(durationStats.mean)),
        Statistic(title: "Median Duration", value: formatTimeInterval(durationStats.median)),
        Statistic(title: "Minimum Duration", value: formatTimeInterval(durationStats.min)),
        Statistic(title: "Maximum Duration", value: formatTimeInterval(durationStats.max)),
        Statistic(title: "Total Duration", value: formatTimeInterval(durationStats.total)),
        Statistic(title: "Duration Range", value: formatTimeInterval(durationStats.range)),
        Statistic(title: "Duration Variance", value: formatTimeInterval(durationStats.variance)),
        Statistic(title: "Duration Standard Deviation", value: formatTimeInterval(durationStats.stdDev))
    ])

    // Interval Statistics
    intervalStatisticsArray.append(contentsOf: [
        Statistic(title: "Mean Interval", value: formatTimeInterval(intervalStats.mean)),
        Statistic(title: "Median Interval", value: formatTimeInterval(intervalStats.median)),
        Statistic(title: "Minimum Interval", value: formatTimeInterval(intervalStats.min)),
        Statistic(title: "Maximum Interval", value: formatTimeInterval(intervalStats.max)),
        Statistic(title: "Total Interval", value: formatTimeInterval(intervalStats.total)),
        Statistic(title: "Interval Range", value: formatTimeInterval(intervalStats.range)),
        Statistic(title: "Interval Variance", value: formatTimeInterval(intervalStats.variance)),
        Statistic(title: "Interval Standard Deviation", value: formatTimeInterval(intervalStats.stdDev))
    ])

    // Other Statistics
    otherStatisticsArray.append(contentsOf: [
        Statistic(title: "Total Event Count", value: "\(events.count)"),
        Statistic(title: "Count of Events with Missing End Dates", value: "\(countMissingEndDates)")
    ])

    return Statistics(durationStatistics: durationStatisticsArray, intervalStatistics: intervalStatisticsArray, otherStatistics: otherStatisticsArray)
}

func formatTimeInterval(_ interval: TimeInterval) -> String {
        let hours = interval / 3600
        let minutes = (interval / 60).truncatingRemainder(dividingBy: 60)
        let seconds = interval.truncatingRemainder(dividingBy: 60)

        if hours >= 1 {
            return String(format: "%.2f hours", hours)
        } else if minutes >= 1 {
            return String(format: "%.2f minutes", minutes)
        } else {
            return String(format: "%.2f seconds", seconds)
        }
    

}


func calculateTimeStats(from timeIntervals: [TimeInterval]) -> (mean: TimeInterval, median: TimeInterval, min: TimeInterval, max: TimeInterval, total: TimeInterval, range: TimeInterval, variance: TimeInterval, stdDev: TimeInterval) {
    let sortedIntervals = timeIntervals.sorted()
    let total = sortedIntervals.reduce(0, +)
    let mean = total / Double(sortedIntervals.count)
    let median = sortedIntervals.count % 2 == 0 ? (sortedIntervals[sortedIntervals.count / 2 - 1] + sortedIntervals[sortedIntervals.count / 2]) / 2 : sortedIntervals[sortedIntervals.count / 2]
    let min = sortedIntervals.first ?? 0
    let max = sortedIntervals.last ?? 0
    let range = max - min
    let variance = sortedIntervals.reduce(0) { $0 + pow($1 - mean, 2) } / Double(sortedIntervals.count)
    let stdDev = sqrt(variance)

    return (mean, median, min, max, total, range, variance, stdDev)
}
