//
//  HabitGroupsList.swift
//  Habits
//
//  Created by Ryan on 25/11/2023.
//

import SwiftUI

struct HabitGroupsList: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest(entity: HabitGroup.entity(), sortDescriptors: [])
    var groups: FetchedResults<HabitGroup>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(groups) { group in
                    HStack {
                        Image(systemName: group.symbolName!)
                        Text("\(group.name!)")
                    }
                }
            }
            .navigationTitle("Habits")
            .plusToolbarButton {
                
            }
            
        }
    }
}

#Preview {
    HabitGroupsList()
}
