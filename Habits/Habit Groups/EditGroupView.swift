//
//  EditGroupView.swift
//  Habits
//
//  Created by Ryan on 25/11/2023.
//

import SwiftUI

struct EditGroupView: View {
    
    enum FocusedField {
        case folderName
    }
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var focusedField: FocusedField?
    
    @State var text = ""
    
    @Binding var gridMode: HabitGrid.HabitGridMode
    
    @State var existingGroup: HabitGroup?
    
    @State var showEditHabits = false
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                Section(content: {
                    TextField("Folder Name", text: $text)
                        .focused($focusedField, equals: .folderName)
                }, header: {
                    
                    HStack {
                        Spacer()
                        Image(systemName: "folder")
                            .font(.habitsFont(size: 90))
                        Spacer()
                    }
                    .padding(.vertical, 50)
                    
                    
                })
                
                Section {
                    
                    Button(action: {
                        showEditHabits = true
                    }, label: {
                        
                        Text("Manage Habits")
                        
                    })
                    
                    
                    if existingGroup?.name != nil {
                        
                        
                        Button("Delete Group", role: .destructive, action: {
                            
                            let context = PersistenceController.shared.container.viewContext
                            
                            context.delete(existingGroup!)
                            
                            try? context.save()
                            
                            dismiss()
                            
                            
                        })
                    }
                    
                }
                    
                
                
            }
            .onAppear() {
                focusedField = .folderName
            }
            .formToolbar(onCancel: {
                dismiss()
            }, onSave: {
                save()
            }, allowSave: containsLettersOrNumbers(text))
            .sheet(isPresented: $showEditHabits) {
                EditGroupHabitsView(group: existingGroup!)
            }
            
        }
        
    }
    
    private func save() {
        
        var group: HabitGroup
        
        if let existingGroup {
            group = existingGroup
        } else {
            group = HabitGroup(context: context)
        }

        group.created = Date()
        group.name = text
        context.insert(group)
        try? context.save()
        dismiss()
        
        DispatchQueue.main.async {
            gridMode = .group(group)
        }
        
    }
    
    func containsLettersOrNumbers(_ input: String) -> Bool {
        let characterSet = CharacterSet.alphanumerics
        return input.rangeOfCharacter(from: characterSet) != nil
    }
    
}

#Preview {
    EditGroupView(gridMode: .constant(.allHabits))
}
