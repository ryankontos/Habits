//
//  StatisticsView.swift
//  Habits
//
//  Created by Ryan on 26/11/2023.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    
    var habit: Habit
    
    @State var stats: EventStatistics?
    
    @Environment(\.colorScheme) var scheme
    

    
    var events: [Event] {
        return habit.events?.allObjects as! [Event]
        
    }
    
    var body: some View {
        
        ZStack {
            
            let grad =  Gradient(stops: [
                .init(color: habit.color.opacity(0.45), location: 0.1),
                .init(color:  scheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGroupedBackground), location: 0.45)
            ])
            
            LinearGradient(gradient: grad, startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
           
            ScrollView {
                
                
                
                VStack {
                    
                  
                    
                    ProminentHeaderSection("Chart") {
                        
                        StatsCard("Total Events: Last 30 Days", habit: habit, content: {
                            
                            EventTotalChart(habit: habit)
                            
                        })
                        
                        StatsCard("Hours", habit: habit) {
                            
                            HourGraph(habit: habit)
                            
                        }
                        
                       
                        
                    }
                    
                 
                    NavigationLink("All Data", destination: {
                        AllEventsList(habit: habit)
                    })
                    
                }
                .padding(.horizontal)
                .padding(.top, 13)
                    
            }
            
            .navigationTitle("Shower")
            .scrollContentBackground(.hidden)
            .onAppear() {
             
                
            }
            
        }
        
    }
    
    func card() -> some View {
        
        RoundedRectangle(cornerRadius: 15)
            .foregroundStyle(scheme == .dark ? Color(UIColor.secondarySystemBackground) : Color.white)
            .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
            .overlay(content: {
                VStack {
                    
                    Text("Latest")
                    
                }
            })
        
        
    }
    
    func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .hour, .minute, .second]
        formatter.unitsStyle = .short
        formatter.zeroFormattingBehavior = .pad

        return formatter.string(from: interval)!
    }

}


#Preview {
    NavigationStack {
        StatisticsView(habit: .previewHabit(name: "Shower", color: .pink, symbolName: "shower.fill", hasDuration: true))
    }
}

