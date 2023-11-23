//
//  Habits_WatchApp.swift
//  Habits Watch Watch App
//
//  Created by Ryan on 16/11/2023.
//

import SwiftUI

@main
struct Habits_Watch_Watch_AppApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onOpenURL { url in
                    print("Opening url")
                                guard url.scheme == "widget-deeplink" else { return }
                    
                                
                            }
                .onContinueUserActivity(/*@START_MENU_TOKEN@*/"Activity"/*@END_MENU_TOKEN@*/, perform: { userActivity in
                    print("Continuing activity")
                })
                .onAppear() {
                    print("Appear")
                }
            
        }
        
    }
    
    
    
}
