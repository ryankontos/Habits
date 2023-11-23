//
//  ContentView.swift
//  TimeSince
//
//  Created by Ryan on 13/11/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView {
            Group {
                
                HabitGrid()
                    
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                        Text("Log")
                    }
                    .onAppear {
                        ActivityManager.updateActivities()
                    }
                
                BrowseDataView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Browse") }
                
            }
           
            .toolbarBackground(.visible, for: .tabBar)
            /*.safeAreaInset(edge: .bottom, content: {
                
                HStack {
                    
                  
                    
                    VStack(spacing: 10) {
                        
                        Text("Logged Shower")
                        
                        HStack {
                            
                            Text("Undo")
                                .foregroundStyle(.blue)
                            
                            
                            
                        }
                        
                    }
                    
                  
                    
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background() {
                    
                    RoundedRectangle(cornerRadius: 15)
                       
                        
                        .foregroundStyle(.ultraThickMaterial)
                       
                   
                    
                }
               
                .padding(.bottom, 20)
                
               
                   
                
                
            })*/
           
        }
        
        .tabViewStyle(.automatic)
        
        
    }
}

#Preview {
    ContentView()
}
