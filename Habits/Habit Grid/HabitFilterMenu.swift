//
//  HabitFilterMenu.swift
//  Habits
//
//  Created by Ryan on 29/11/2023.
//

import SwiftUI

struct HabitFilterMenu: View {
    
    @FetchRequest(
        entity: HabitGroup.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \HabitGroup.created, ascending: true)],
        predicate: NSPredicate(format: "name != nil")
    ) var groups: FetchedResults<HabitGroup>

    
    @Binding var mode: HabitGrid.HabitGridMode
    
    @Binding var creatingNewGroup: HabitGroup?
    
    var body: some View {
        
        Group {
            
            Button(action: {
                
                withAnimation {
                    mode = .allHabits
                    FeedbackManager.shared.selectionChanged()
                }
                
            }, label: {
                
                if mode == .allHabits {
                    Image(systemName: "checkmark")
                }
                
                Text("All Habits")
            })
            
            
            Divider()
            
            ForEach(groups) { group in
                
                Button(action: {
                    
                    withAnimation {
                        mode = .group(group)
                        FeedbackManager.shared.selectionChanged()
                    }
                    
                    
                    
                }, label: {
                    
                    
                    if mode == .group(group) {
                        Image(systemName: "checkmark")
                    }
                    
                    Text(group.name ?? "Unnamed Group")
                })
                
                
            }
            
            Divider()
            
            Button(action: {
                
                let context = PersistenceController.shared.container.viewContext
                
                let object = HabitGroup(context: context)
                object.created = Date()
                
                creatingNewGroup = object
                
            }, label: {
                Image(systemName: "plus")
                Text("Create New Group")
            })
            
        }
        
    }
}

