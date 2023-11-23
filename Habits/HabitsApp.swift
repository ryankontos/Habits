//
//  HabitsApp.swift
//  Habits
//
//  Created by Ryan on 16/11/2023.
//

import SwiftUI

@main
struct HabitsApp: App {
   
    let persistenceController = PersistenceController.shared
    
    init() {
        ValueTransformer.setValueTransformer(
              SerializableColorTransformer(),
              forName: NSValueTransformerName(
                rawValue: "SerializableColorTransformer"))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    ActivityManager.updateActivities()
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
        
    }
    
}
