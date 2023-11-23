//
//  Habits_WidgetsBundle.swift
//  Habits Widgets
//
//  Created by Ryan on 17/11/2023.
//

import WidgetKit
import SwiftUI

@main
struct Habits_WidgetsBundle: WidgetBundle {
    var body: some Widget {
        
        #if os(iOS)
        
        Habits_Widgets()
        
        #endif
        
        #if os(watchOS)
        
        Habits_Watch_Widgets()
        
        #endif
        
        #if canImport(ActivityKit)
            Habits_WidgetsLiveActivity()
        #endif
    }
}
