//
//  CircleIconButton.swift
//  Habits
//
//  Created by Ryan on 20/11/2023.
//

import SwiftUI

struct CircleIconButtonView: View {
    let color: Color
    let iconName: String
    let buttonSize: CGFloat
    let fontSize: CGFloat

    var body: some View {
       
            Circle()
                .foregroundColor(color.opacity(0.2))
                .frame(width: buttonSize, height: buttonSize)
                .overlay {
                    Image(systemName: iconName)
                        .foregroundColor(color)
                        .font(.system(size: fontSize))
                        .fontWeight(.semibold)
                }
 
    }
}

#Preview {
    CircleIconButtonView(color: .green, iconName: "checkmark", buttonSize: 50, fontSize: 20)
}
