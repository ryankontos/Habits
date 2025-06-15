//
//  FormToolbarModifier.swift
//  Habits
//
//  Created by Ryan on 25/11/2023.
//

import SwiftUI

struct FormToolbarModifier: ViewModifier {
    
    let onCancel: () -> Void
    let onSave: () -> Void
    
    var allowSave: Bool
    
    var tint: Color?
    
    @Environment(\.dismiss) private var dismiss

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        onCancel()
                    }
                    .tint(tint)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onSave()
                    }
                    .tint(tint)
                    .disabled(!allowSave)
                    .fontWeight(.medium)
                }
                
            }
    }
}

extension View {
    func formToolbar(onCancel: @escaping () -> Void, onSave: @escaping () -> Void, allowSave: Bool = true, tint: Color? = nil) -> some View {
        self.modifier(FormToolbarModifier(onCancel: onCancel, onSave: onSave, allowSave: allowSave, tint: tint))
    }
}
