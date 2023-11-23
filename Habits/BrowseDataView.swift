//
//  BrowseDataView.swift
//  TimeSince
//
//  Created by Ryan on 13/11/2023.
//

import SwiftUI

struct BrowseDataView: View {
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.listOrder)]) var habits: FetchedResults<Habit>
    
    
    @State var searchText = ""
    
    @State private var presentedHabits: [Habit] = []
    
    var body: some View {
        NavigationStack(path: $presentedHabits) {
            
            List {
                
                Section(content: {
                    
                    ForEach(habits) { habit in
                        
                        NavigationLink(value: habit, label: {
                           
                            HStack(spacing: 10) {
                                
                                Image(systemName: habit.symbolName!)
                                    .foregroundStyle(habit.color)
                                    .frame(width: 30)
                                    .font(.system(size: 19))
                                
                                Text(habit.name!)
                                
                            }
                        })
                        
                    }
                    
                }, header: {
                    Text("Habit Categories")
                        .padding(.leading, -20)
                        .headerProminence(.increased)
                })
                
             
                
            }
            .environment(\.defaultMinListRowHeight, 53)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
            .navigationTitle("Data")
            .navigationDestination(for: Habit.self) { habit in
                
                AllEventsList(habit: habit)
                
            }
            
        }
    }
}

#Preview {
    BrowseDataView()
}
