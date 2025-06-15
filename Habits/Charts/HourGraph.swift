//
//  HourGraph.swift
//  Habits
//
//  Created by Ryan on 14/12/2023.
//

import SwiftUI
import Charts

struct HourGraph: View {
    
    var habit: Habit
    
    @State var range: (Int, Int)?
    
    var body: some View {
        Chart {
            
            ForEach(countDatesByHour(dates: habit.eventsArray.compactMap({
                $0.startDate
            })), id: \.0) { (date, count) in
                
                BarMark(
                    x: .value("Hour", date),
                    y: .value("Count", count)
                )
                .foregroundStyle(habit.color)
                .interpolationMethod(.catmullRom)
               
                
            }
            
            
            
        }
        .chartPlotStyle{plotArea in
            plotArea.frame(maxWidth: .infinity, minHeight: 250.0, maxHeight: 250.0)
        }
        .chartOverlay { proxy in
                    GeometryReader { nthGeoItem in
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .gesture(DragGesture()
                                .onChanged { value in
                                    // Find the x-coordinates in the chart’s plot area.
                                    let xStart = value.startLocation.x - nthGeoItem[proxy.plotAreaFrame].origin.x
                                    let xCurrent = value.location.x - nthGeoItem[proxy.plotAreaFrame].origin.x
                                    // Find the date values at the x-coordinates.
                                    if let dateStart: Int = proxy.value(atX: xStart),
                                       let dateCurrent: Int = proxy.value(atX: xCurrent) {
                                        range = (dateStart, dateCurrent)
                                    }
                                }
                                .onEnded { _ in range = nil } // Clear the state on gesture end.
                            )
                    }
                }
            }
    }
    
    
    func countDatesByHour(dates: [Date]) -> [(Int, Int)] {
        var hourCounts = [Int: Int]()

        // Count the occurrences of each hour
        for date in dates {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            hourCounts[hour, default: 0] += 1
        }

        // Convert the dictionary to an array of tuples
        return hourCounts.map { ($0.key, $0.value) }.sorted { $0.0 < $1.0 }
    }


#Preview {
    HourGraph(habit: .previewHabit())
}
