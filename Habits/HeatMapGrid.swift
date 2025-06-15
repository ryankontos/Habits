//
//  HeatMapGrid.swift
//  Habits
//
//  Created by Ryan on 30/11/2023.
//

import SwiftUI

struct HeatMapGrid: View {
    
    var occurrences: [DateGrouper.DateOccurrence]
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 5), count: 7)
    
    var body: some View {
        
        LazyVGrid(columns: columns, spacing: 5) {
            
        ForEach(occurrences) { occurence in
                
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.red, lineWidth: occurence.date == Date().startOfDay() ? 2 : 0)
                .fill(getFillFor(num: occurence.count))
                .frame(minWidth: 0, maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(8)
            }
        }
        
    }
}

