//
//  ColorOptionsList.swift
//  TimeSince
//
//  Created by Ryan on 15/11/2023.
//

import SwiftUI

struct ColorOptionsList: View {
    
    static let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .cyan, .indigo, .pink, .mint, .brown]
    
   
    
    @Binding var selection: Color
    
    
    var body: some View {
        
        ScrollViewReader { reader in
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            
            HStack {
                
                Spacer(minLength: 15)
                
                
                HStack(spacing: 5) {
                    
                    ForEach(ColorOptionsList.colors, id: \.self) { color in
                        
                       
                        
                        Button(action: {
                            
                            selection = color
                            
                            #if os(iOS)
                            
                            FeedbackManager.shared.selectionChanged()
                            
                            #endif
                            
                        }, label: {
                            Circle()
                                
                                .strokeBorder(Color.primary.opacity(SerializableColor(from: selection).description == SerializableColor(from: color).description ? 0.3 : 0.0), lineWidth: 3)
                                .background(Circle()
                                    .fill(color.gradient)
                                    .padding(.all, 6.5)
                                )
                                .id(SerializableColor(from: color).description)
                                .frame(width: 55)
                        })
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                }
                
                
                
            }
            .onAppear() {
                
                for color in ColorOptionsList.colors {
                    
                    if SerializableColor(from: selection).description == SerializableColor(from: color).description {
                        reader.scrollTo(SerializableColor(from: color).description, anchor: .trailing)
                    }
                    
                }
                
            }
      
            
            
            
        }
            
        
    }
       
        
    }
}

#Preview {
    
    @State var color = Color.blue
    
    return ColorOptionsList(selection: $color)
}
