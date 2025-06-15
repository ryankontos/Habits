//
//  HabitsTabView.swift
//  Habits
//
//  Created by Ryan on 26/11/2023.
//

import SwiftUI

struct HabitsTabView: View {
    
    @Binding var selection: Int
    
    @Binding var browsePath: NavigationPath
    
    @State var mode: HabitGrid.HabitGridMode = .allHabits
    
    var body: some View {
        TabView(selection: $selection) {

                NavigationStack {
                    HabitGrid(mode: $mode)
                }
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Log")
                }
                .tag(1)
                NavigationStack(path: $browsePath) {
                    BrowseDataView()
                }
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Browse") }
                .tag(2)
            
            .toolbarBackground(.visible, for: .tabBar)
        }
        
        .tabViewStyle(.automatic)
    }
}

#Preview {
    HabitsTabView(selection: .constant(0), browsePath: .constant(.init()))
}
