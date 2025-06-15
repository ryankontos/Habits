//
//  HabitGroupsList.swift
//  Habits
//
//  Created by Ryan on 25/11/2023.
//

import SwiftUI

struct HabitGroupsList: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @State private var navPath = NavigationPath()
    
    @FetchRequest(entity: HabitGroup.entity(), sortDescriptors: [])
    var groups: FetchedResults<HabitGroup>
    
    @State var showEditGroupView = false
    
    @State var doneAdd = false
    
    @State var showAll = false
    var body: some View {
        NavigationStack(path: $navPath) {
            
            
            List {
                
                Section {
                   
                    NavigationLink(value: HabitGrid.HabitGridMode.allHabits, label: {
                        HStack {
                            Image(systemName: "rectangle.grid.2x2.fill")
                                .foregroundStyle(.tint)
                            Text("All Habits")
                        }
                    })
                    
                    
                }
                
                Section("Groups") {
                    
                    ForEach(groups) { group in
                        
                        NavigationLink(value: HabitGrid.HabitGridMode.group(group) ,label: {
                            HStack {
                                Image(systemName: "folder")
                                    .foregroundStyle(.tint)
                                Text("\(group.name!)")
                            }
                        })
                        
                        
                    }
                    .onDelete(perform: deleteGroup)
                    
                    
                }
            }
            
           
            
            .navigationTitle("Habits")
           
            .plusToolbarButton {
                showEditGroupView = true
            }
            
        }
        .onAppear() {
            if doneAdd { return }
            navPath.append(HabitGrid.HabitGridMode.allHabits)
            doneAdd = true
        }
    }
    
    func deleteGroup(at offsets: IndexSet) {
            for index in offsets {
                let groupToDelete = groups[index]
                context.delete(groupToDelete)
            }
            
            do {
                try context.save()
            } catch {
                // Handle the error here, e.g., show an alert
                print("Error deleting group: \(error.localizedDescription)")
            }
        
    }
    
}

#Preview {
    HabitGroupsList()
}
