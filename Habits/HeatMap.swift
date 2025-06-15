//
//  HeatMap.swift
//  Habits
//
//  Created by Ryan on 29/11/2023.
//

import SwiftUI
import Charts



struct HeatMap: View {
    
    var events: [Event]
    
    func getData() -> [DateGrouper.DateGroup] {
        
        let dates = events.map({ return $0.startDate! })
        return DateGrouper.generateDateGroups(from: dates, grouping: .month)
    }
    

    var body: some View {
        
        ZStack {
            
            Color(uiColor: .secondarySystemBackground).ignoresSafeArea(.all)
            
            ScrollView {
                
                VStack {
                    
                    ForEach(getData()) { dateGroup in
                        
                        HStack {
                            Text("\(dateGroup.description)")
                                .font(.system(size: 22))
                                .fontWeight(.semibold)
                            Spacer()
                        }
                       
                        
                        
                        
                        HeatMapGrid(occurrences: dateGroup.occurrences)
                            .padding(.bottom, 25)
                        
                    }
                    .padding(.horizontal, 35)
                    
                }
                .frame(maxWidth: 600)
                .padding(.top, 30)
            }
            .scrollIndicators(.hidden, axes: .vertical)
            .toolbar(.hidden, for: .tabBar)
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("Heat Map")
            
        }
        
    }

    }

func getFillFor(num: Int) -> Color {
    
    if num == -1 {
        return .gray.opacity(0.2)
    }
    
    if num == 0 {
        return .gray.opacity(0.2)
    }
    
    return .cyan.opacity(0.9)
    
}

#Preview {
    HeatMap(events: [])
}
    

