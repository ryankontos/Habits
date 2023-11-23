//
//  HabitSummaryView.swift
//  Habits
//
//  Created by Ryan on 16/11/2023.
//

import SwiftUI

struct HabitSummaryView: View {
    
    @State var selection = "D"
    
    var body: some View {
        
        ScrollView {
            
            Picker(selection: $selection, content: {
                Text("D")
                    .tag("D")
                Text("W") 
                    .tag("W")
                Text("M")
                    .tag("M")
                Text("6M")
                    .tag("6M")
                Text("Y")
                    .tag("Y")
            }, label: {
                Text("Interval")
            })
            .pickerStyle(.segmented)
            .padding(.top, 15)
            .padding(.horizontal, 20)
            
        }
        .toolbarTitleDisplayMode(.inline)
        .navigationTitle("Shower")
        .toolbarBackground(.visible, for: .navigationBar)
        
    }
}

#Preview {
    
    NavigationStack {
        
        HabitSummaryView()
    }
    
}
