//
//  PlusMenuButtonModifier.swift
//  Habits
//
//  Created by Ryan on 25/11/2023.
//

import Foundation
import SwiftUI

struct PlusMenuButtonModifier<Content>: ViewModifier where Content: View {
    var menuContent: () -> Content

    func body(content: _ViewModifier_Content<PlusMenuButtonModifier>) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu(content: {
                        menuContent()
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
           
    }
}

extension View {
    func plusMenuButton<Content>(@ViewBuilder menuContent: @escaping () -> Content) -> some View where Content: View {
        modifier(PlusMenuButtonModifier(menuContent: menuContent))
    }
}
