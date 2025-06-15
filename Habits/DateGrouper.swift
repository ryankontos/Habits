//
//  DateGrouper.swift
//  Habits
//
//  Created by Ryan on 30/11/2023.
//

import Foundation

class DateGrouper {
    
    static func generateDateGroups(from dates: [Date], grouping: DateGrouping) -> [DateGroup] {
        var groups = [DateGroup]()
        let calendar = Calendar.current

        // Find the earliest and latest dates
        guard let firstEventDate = dates.map({ $0 }).min(),
              let latestDate = dates.map({ $0 }).max() else {
            return []
        }

        // Adjust the earliest date to the previous Monday
        
        var startDate = firstEventDate.startOfDay()
        var endDate = latestDate.startOfDay()
        
        if grouping == .year {
            
            
            while calendar.component(.day, from: startDate) != 1 { // 2 represents Monday in Gregorian calendar
                startDate = calendar.date(byAdding: .day, value: -1, to: startDate)!
            }
            
            // Adjust the latest date to the next Sunday
          
            while calendar.component(.weekday, from: endDate) != 1 { // 1 represents Sunday in Gregorian calendar
                endDate = calendar.date(byAdding: .day, value: 1, to: endDate)!
            }
            
            
        } else if grouping == .month {
            
            startDate = startDate.startOfMonth()
            endDate = endDate.endOfMonth()
            
        }

        
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)

        if let days = components.day, days < 365 {
            // Run your code here if the time difference is less than 365 days
            endDate = calendar.date(byAdding: .day, value: 365, to: endDate)!.endOfMonth()
        }

        // Create a range of dates from the adjusted start date to the adjusted end date
        
        var occurrencesDict = [Date:Int]()
        
        for date in dates {
            let start = date.startOfDay()
            if occurrencesDict[start] == nil {
                occurrencesDict[start] = 1
            } else {
                occurrencesDict[start]! += 1
            }
        }
        
        var currentDate = startDate.startOfDay()

        while currentDate <= endDate {
            if occurrencesDict[currentDate] == nil {
                occurrencesDict[currentDate] = 0
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        // Group the occurrences based on the selected grouping option
        for (date, count) in occurrencesDict.sorted(by: { $0.key < $1.key }) {
            print("Date: \(date.formatted(date: .abbreviated, time: .omitted))")
            let occurrence = DateOccurrence(date: date, count: count)
            let groupKey: String

            switch grouping {
            
            case .month:
                let month = calendar.component(.month, from: date)
                groupKey = "\(calendar.monthSymbols[month - 1]) \(calendar.component(.year, from: date))"
            case .year:
                groupKey = "\(calendar.component(.year, from: date))"
            case .none:
                groupKey = ""
            }

            if let index = groups.firstIndex(where: { $0.description == groupKey }) {
                groups[index].occurrences.append(occurrence)
            } else {
                groups.append(DateGroup(description: groupKey, occurrences: [occurrence]))
            }
        }

  
        return groups
    }
    
    enum DateGrouping {
        case month, year, none
    }

    // Structs for date occurrences and groups
    struct DateOccurrence: Identifiable {
        
        var id: Date {
            return date
        }
        
        let date: Date
        var count: Int
    }

    struct DateGroup: Identifiable {
        
        var id: String {
            return description
        }
        
        let description: String
        var occurrences: [DateOccurrence]
    }

    
}

extension Date {
    
    func startOfWeek() -> Date {
        let components = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return Calendar.current.date(from: components)!.startOfDay()
        }

        func endOfWeek() -> Date {
            let startOfWeek = self.startOfWeek()
            return Calendar.current.date(byAdding: DateComponents(day: 6), to: startOfWeek)!.startOfDay()
        }
    
    func startOfMonth() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }
    
    

    func endOfMonth() -> Date {
        let calendar = Calendar.current
        let startOfMonth = self.startOfMonth()
        
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
            return calendar.date(byAdding: .day, value: -1, to: nextMonth)!
        
       
        
    }
    
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
        
    }
    
    func getDayOfMonth() -> Int {
        
        return Calendar.current.component(.day, from: self)
        
    }
}
