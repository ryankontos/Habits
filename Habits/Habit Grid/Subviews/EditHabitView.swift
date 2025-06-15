//
//  EditHabitView.swift
//  TimeSince
//
//  Created by Ryan on 14/11/2023.
//

import SwiftUI
import SymbolPicker
import LocalAuthentication

struct EditHabitView: View {
    
    enum HabitDurationType {
        case moment
        case timed
    }
    
    enum FocusedField {
        case habitName
    }
    
    @Environment(\.dismiss) private var dismiss
    @FetchRequest(sortDescriptors: [SortDescriptor(\.listOrder)]) var habits: FetchedResults<Habit>
    @Environment(\.managedObjectContext) var context
    
    @State var name = ""
    @State var color: Color = ColorOptionsList.colors.randomElement()!
    @State var useCustomColor = false
    @State var symbolName = "sparkles"
    @State var showSymbolPicker = false
    @State var hasDuration = false
    @State var secure = false
    @State var selectedMode: HabitDurationType = .moment
    @FocusState private var focusedField: FocusedField?

    
    @State var showDeleteAlert = false
    
    private var group: HabitGroup? // If we have a group, we want to add this habit to it upon creation
    
    private var existingHabit: Habit?
    
    init(_ habit: Habit? = nil, group: HabitGroup?) {
        self.group = group
        guard let habit = habit else { return }
        self.existingHabit = habit
        
    
        
       
    }

    var isFormValid: Bool {
        return name.isEmpty == false && symbolName.isEmpty == false
    }
    
    var body: some View {
        NavigationStack {
            Form {
                
                if let group, existingHabit == nil {
                    
                    Section {
                        
                        HStack {
                            
                            Spacer()
                            
                            Text("This habit will be automatically added to \(group.name!).")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                         
                            Spacer()
                            
                        }
                    }
                    
                }
                
                Section(content: {
                    TextField("Name", text: $name)
                        .focused($focusedField, equals: .habitName)
                }, header: {
                    headerView
                })
                Section(content: {
                    if useCustomColor {
                        ColorPicker("Color", selection: $color, supportsOpacity: false)
                    } else {
                        ColorOptionsList(selection: $color)
                            .frame(height: 45)
                            .padding(.horizontal, -20)
                    }
                    
                    Toggle("Custom Color", isOn: $useCustomColor.animation())
                }, header: {
                    Text("Color")
                })
                
                Section(content: {
                    
                    Toggle(isOn: $hasDuration, label: {
                        
                        HStack {
                            
                            Image(systemName: "stopwatch")
                            Text("Timed Habit")
                            
                        }
                        
                    })
                    
                   
                    
                   
                }, header: {
                    Text("Habit Type")
                }, footer: {
                    Text("Timed habits can have an end date as well as a start date. Enable this when you want to track the length of an event.")
                })
                
                Section(content: {
                    
                    Toggle(isOn: $hasDuration, label: {
                        
                        HStack {
                            
                            Image(systemName: "lock.fill")
                            Text("Hidden Habit")
                            
                        }
                        
                    })
                    
                   
                    
                   
                
                }, footer: {
                    Text(getHiddenInfoString())
                })
                
                if existingHabit != nil {
                    Section {
                        Button(role: .destructive, action: {
                            self.showDeleteAlert = true
                            
                        }, label: {
                            Text("Delete Habit")
                        })
                    }
                }
            }
            .onAppear {
                focusedField = .habitName
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            
            
            .formToolbar(onCancel: {
                self.dismiss()
            }, onSave: {
                save()
            }, allowSave: isFormValid, tint: color)
       
            
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
        .deleteHabitAlert(showAlert: $showDeleteAlert, habit: existingHabit, dismissAfterDelete: true)
        
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
                        .font(.habitsFont(size: 70))
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
                    .font(.habitsFont(size: 14))
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
            
            if let group {
                
                group.addHabit(habit: habit)
                
            }
            
        }
        
        try? context.save()
        self.dismiss()
        
    }
    
    
    func getHiddenInfoString() -> String {
        
        let type = EditHabitView.biometricType()
        
        if [BiometricType.face, .optic, .touch].contains(type) {
            
            return "Hidden habits are hidden from the app by default, and can unlocked with \(type.rawValue) or your device passcode."
            
        } else {
            
            return "Hidden habits are hidden from the app by default, and can unlocked with your device passcode."
            
        }
        
    }
    

    static func biometricType() -> BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                return .none
            case .touchID:
                return .touch
            case .faceID:
                return .face
            case .opticID:
                return .optic
            @unknown default:
                return .none
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
        }
    }

    enum BiometricType: String {
        case none
        case touch = "Touch ID"
        case face = "Face ID"
        case optic = "Optic ID"
    }
    
}


#Preview {
    EditHabitView(group: nil)
}
