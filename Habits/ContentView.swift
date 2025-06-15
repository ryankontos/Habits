//
//  ContentView.swift
//  TimeSince
//
//  Created by Ryan on 13/11/2023.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var selection = 0
    
    @State var browsePath = NavigationPath()
    
    var body: some View {
        
        
            
            HabitsTabView(selection: $selection, browsePath: $browsePath)
            
            
        
        
     
        
    }
}

#Preview {
    ContentView()
}
