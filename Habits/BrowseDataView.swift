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
    

    
    var body: some View {
       
        ZStack {
            
            AppBackground().ignoresSafeArea(.all)
            
            List {
                
                Section(content: {
                    
                    ForEach(habits) { habit in
                        
                        NavigationLink(value: habit, label: {
                            
                            HStack(spacing: 10) {
                                
                                Image(systemName: habit.symbolName!)
                                    .foregroundStyle(habit.color)
                                    .frame(width: 30)
                                    .font(.habitsFont(size: 19))
                                
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
           // .scrollContentBackground(.hidden)
            .environment(\.defaultMinListRowHeight, 53)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
            .navigationTitle("Data")
            .navigationDestination(for: Habit.self) { habit in
                
                StatisticsView(habit: habit)
                
            }
        }
          
            
        
    }
}

#Preview {
    BrowseDataView()
}
