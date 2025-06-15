//
//  PlusButtonModifier.swift
//  Habits
//
//  Created by Ryan on 25/11/2023.
//

import Foundation
import SwiftUI

struct PlusButtonModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        self.action()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.primary, .secondary)
                    }
                }
            }
    }
}

extension View {
    func plusToolbarButton(_ action: @escaping () -> Void) -> some View {
        self.modifier(PlusButtonModifier(action: action))
    }
}
