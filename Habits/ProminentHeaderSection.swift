//
//  ProminentHeaderSection.swift
//  Habits
//
//  Created by Ryan on 7/12/2023.
//

import SwiftUI

struct ProminentHeaderSection<Content: View>: View {
    let content: Content
    let title: String?

    init(_ title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        Section {
            VStack {
                content
            }
            .padding(.top, 2)
        } header: {
            
            if let title {
                HStack {
                    Text(title)
                        .font(.system(size: 21.5, weight: .semibold))
                    Spacer()
                }
            }
            
           
        }
        .padding(.bottom, 13)
    }
}

#Preview {
    ProminentHeaderSection("Section") {
        
    }
}
