//
//  DataCard.swift
//  Habits
//
//  Created by Ryan on 30/11/2023.
//

import SwiftUI

struct DataCard: View {
    var body: some View {
       
       
        
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Total Logs")
                .font(.habitsFont(size: 17))
                .fontWeight(.semibold)
            
            Text("6")
                .font(.habitsFont(size: 30))
            
        }
        
    }
}

#Preview {
    DataCard()
}
