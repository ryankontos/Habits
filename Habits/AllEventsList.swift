//
//  AllEventsList.swift
//  TimeSince
//
//  Created by Ryan on 16/11/2023.
//

import SwiftUI

struct AllEventsList: View {
    
    @ObservedObject var habit: Habit
    @Environment(\.managedObjectContext) var managedObjectContext
    
    public var events: [Event] {
        let set = habit.events?.allObjects as? [Event] ?? []
        return set
    }
    
    var body: some View {
        
        List {
            
            ForEach(events) { event in
                
                HStack {
                    
                    Image(systemName: habit.symbolName!)
                        .foregroundColor(habit.color)
                    
                    VStack(alignment: .leading) {
                        Text(getFormattedDate(event.startDate!))
                        if let end = event.endDate {
                            Text("End: \(getFormattedDate(end))")
                                .foregroundStyle(.secondary)
                        }
                        
                    }
                    
                  
                    
                    
                    
                }
                
                
            }
            .onDelete(perform: deleteEvents)
            
        }
        
        .navigationTitle("All \(habit.name!) Events")
        .navigationBarTitleDisplayMode(.inline)
    
        
    }
       
    
    func deleteEvents(at offsets: IndexSet) {
        
        for index in offsets {
            let event = events[index]
            managedObjectContext.delete(event)
        }
    
        do {
            try managedObjectContext.save()
        } catch {
           
        }
        
    }
    
    func getFormattedDate(_ date: Date) -> String {
        

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium

        let formattedDateAndTime = dateFormatter.string(from: date)

        return "\(formattedDateAndTime) \(date.timeIntervalSinceReferenceDate)"

        
    }
}


/*#Preview {
    AllEventsList(events: [])
}*/
