//
//  EditHabitView.swift
//  TimeSince
//
//  Created by Ryan on 14/11/2023.
//

import SwiftUI
import SymbolPicker

struct EditHabitView: View {
    
    enum HabitDurationType {
        case moment
        case timed
    }
    
    @Environment(\.dismiss) private var dismiss
    @FetchRequest(sortDescriptors: [SortDescriptor(\.listOrder)]) var habits: FetchedResults<Habit>
    @Environment(\.managedObjectContext) var context
    
    @State var name = ""
    @State var color: Color = Color(UIColor.systemBlue)
    @State var useCustomColor = false
    @State var symbolName = "shower"
    @State var showSymbolPicker = false
    @State var hasDuration = false
    @State var secure = false
    @State var selectedMode: HabitDurationType = .moment
    
    var existingHabit: Habit?
    
    init(_ habit: Habit? = nil) {
        guard let habit = habit else { return }
        self.existingHabit = habit
    }

    var isFormValid: Bool {
        return name.isEmpty == false && symbolName.isEmpty == false
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(content: {
                    TextField("Name", text: $name)
                }, header: {
                    headerView
                })
                Section {
                    if useCustomColor {
                        ColorPicker("Color", selection: $color, supportsOpacity: false)
                    } else {
                        ColorOptionsList(selection: $color)
                            .frame(height: 45)
                            .padding(.horizontal, -20)
                    }
                    
                    Toggle("Custom Color", isOn: $useCustomColor.animation())
                }
                
                Section(content: {
                    
                    Toggle("Timed Habit", isOn: $hasDuration)
                    
                   
                }, header: {
                    Text("Habit Type")
                }, footer: {
                    Text("Timed habits events can have an end date as well as a start date. Enable this when you want to track the length of an event as well as the fact that it occured.")
                })
                
                if let existingHabit = existingHabit {
                    Section {
                        Button(role: .destructive, action: {
                            context.delete(existingHabit)
                            dismiss()
                            
                        }, label: {
                            Text("Delete Habit")
                        })
                    }
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        self.dismiss()
                    }
                }
             
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        save()
                    }
                    .disabled(!isFormValid)
                    .fontWeight(.medium)
                }
            }
            
        }
        .onAppear() {
            
            guard let existingHabit = existingHabit else { return }
            self.name = existingHabit.name!
            self.symbolName = existingHabit.symbolName!
            self.color = existingHabit.color
            self.hasDuration = existingHabit.hasDuration
            self.useCustomColor = existingHabit.usesCustomColor
            
        }
        .sheet(isPresented: $showSymbolPicker) {
            SymbolPicker(symbol: $symbolName)
        }
       
        .onChange(of: useCustomColor) {
            
            if !useCustomColor && !ColorOptionsList.colors.contains(color)  {
                self.color = Color(ColorOptionsList.colors.first!)
            }
            
        }
        
    }
    
    var headerView: some View {
        
        VStack(spacing: 20) {
            
            HStack {
                Spacer()
                
                ZStack {
                    Circle()
                        .foregroundStyle(color.gradient)
                        .opacity(0.8)
                    
                    Image(systemName: symbolName)
                        .foregroundStyle(Color.white)
                        .font(.system(size: 70))
                        .padding(.all, 30)
                       
                    
                    
                }
                .frame(width: 130)
                Spacer()
            }
            
            
            Button(action: {
                showSymbolPicker.toggle()
                
            }, label: {
                Text("Choose Icon")
                    .foregroundStyle(Color.primary)
                    .fontWeight(.bold)
                    .font(.system(size: 14))
                    .textCase(.none)
                    .padding(.horizontal, 17)
                    .padding(.vertical, 10)
                    .background() {
                        Capsule()
                            .foregroundStyle(Color.gray.opacity(0.8))
                            .opacity(0.3)
                    }
            })
            
            
            
        }
        .padding(.bottom, 30)
        .padding(.top, 10)
        
    }
    
    
    func save() {
        
        if let existing = existingHabit {
            existing.color = color
            existing.symbolName = symbolName
            existing.name = name
            existing.hasDuration = hasDuration
            existing.usesCustomColor = useCustomColor
        
        } else {
            let newListOrder = habits.isEmpty ? 0 : habits.map { $0.listOrder }.max()! + 1
            let habit = Habit(context: context)
            habit.name = name
            habit.symbolName = symbolName
            habit.color = color
            habit.listOrder = newListOrder
            habit.hasDuration = hasDuration
            habit.usesCustomColor = useCustomColor
            context.insert(habit)
        }
        
        try? context.save()
        self.dismiss()
        
    }
}

#Preview {
    EditHabitView()
}
