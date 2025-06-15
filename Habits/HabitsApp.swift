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
            LockContainerView()
                .onAppear {
                    
                #if canImport(ActivityKit)
                    
                    ActivityManager.updateActivities()
                    
                    #endif
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
        
    }
    
}

extension Font {
    static func habitsFont(size: CGFloat) -> Font {
        return Font.system(size: size)
    }
}
