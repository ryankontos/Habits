//
//  AWHabitGlanceView.swift
//  Habits Watch Watch App
//
//  Created by Ryan on 22/11/2023.
//

import SwiftUI

struct AWHabitGlanceView: View {
    var body: some View {
        
        GeometryReader { proxy in
            
            ScrollView {
                
                VStack(spacing: 10) {
                    
                    VStack(spacing: 10) {
                        
                        VStack(spacing: 10) {
                            
                            ZStack {
                                Circle()
                                    .opacity(0.25)
                                    .frame(height: 45)
                                
                                Image(systemName: "pill.fill")
                                    .font(.system(size: 22))
                                
                            }
                            .foregroundStyle(.green)
                            
                            Text("Take Meds")
                                .font(.system(size: 16))
                            
                        }
                        
                        VStack(spacing: 10) {
                            
                            
                            VStack(spacing: 3) {
                                
                                Text("Logged 5m ago")
                                Text("12:01pm")
                                
                            }
                            .font(.system(size: 15))
                            .foregroundStyle(.secondary)
                            
                        }
                        
                        
                        Spacer()
                        
                        HStack {
                            Button(action: {}, label: {
                                
                                Text("Log Now")
                                
                                
                            })
                            .tint(.green)
                            .buttonStyle(.automatic)
                            
                            
                        }
                        
                    }
                    .frame(height: proxy.size.height-70)
                    
                    
                }
                
                .frame(height: proxy.size.height)
                
              //  .background(Color.red)
               // .edgesIgnoringSafeArea(.vertical)
                // .background(.red)
                //  .padding(.top, 15)
                
            }
           // .frame(height: proxy.size.height)
            
            
          
            
        }
        .edgesIgnoringSafeArea(.vertical)
    }
}

#Preview {

    AWHabitGlanceView()
}
