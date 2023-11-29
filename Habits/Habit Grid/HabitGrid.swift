import SwiftUI
import CoreData

struct HabitGrid: View {
    
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: [SortDescriptor(\.listOrder)], animation: .default) var habits: FetchedResults<Habit>
    @FetchRequest(
            entity: Event.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Event.startDate, ascending: true)],
            predicate: NSPredicate(format: "isCancelled == %@ AND habitHasDuration == %@", NSNumber(value: false), NSNumber(value: true)), animation: .bouncy) var events: FetchedResults<Event>


    let timerColumns = [GridItem(.adaptive(minimum: 400, maximum: 5000))]
    let columns = [GridItem(.adaptive(minimum: 170, maximum: 300))]

    @State private var searchText = ""
    @State private var showNewHabitSheet = false
    @State private var editingHabit: Habit?
    @State private var timerEvent: Event?
    @State private var showingNewLogSheet = false
    @State private var showActions = false
    @State private var showingActionsFor: Habit?
    @State private var customLogHabit: Habit?
    
    private var actionsBinding: Binding<Bool> {
        Binding(get: {
            return showingActionsFor != nil
        }, set: { _ in
            showingActionsFor = nil
        })
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Group {
                    habitEventsSection
                    habitGrid
                }
                .padding(.horizontal)
                .padding(.top, 1)
            }
            
            
            .plusMenuButton {
                Button(action: { withAnimation(.smooth) { showNewHabitSheet.toggle() } }) {
                    Text("Create Habit")
                    Image(systemName: "plus")
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("Habits")
            .sheet(isPresented: $showNewHabitSheet) { EditHabitView() }
            .sheet(item: $editingHabit) { EditHabitView($0) }
            .sheet(item: $timerEvent) { FullScreenActiveEventView(event: $0).environment(\.managedObjectContext, context) }
            .confirmationDialog("\(showingActionsFor?.name ?? "Habit")", isPresented: actionsBinding, titleVisibility: .visible,presenting: showingActionsFor, actions: { habit in
                
                getHabitSheetButtons(for: habit)
                
            })
            .sheet(item: $customLogHabit) { habit in
                CustomLogView(habit: habit)
                    .presentationDetents([.medium])
            }
       
        }
    }

    private var habitEventsSection: some View {
        LazyVStack {
            if !activeEvents.isEmpty {
                LazyVGrid(columns: timerColumns, spacing: 10) {
                    Section {
                        ForEach(activeEvents, id: \.self) { event in
                            if let habit = event.habit {
                                Button(action: { timerEvent = event }) {
                                    ActiveHabitEventView(habit: habit, event: event)
                                }
                            }
                        }
                    }
                }
                Divider().padding(.vertical, 5)
            }
        }
    }

    private var habitGrid: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(getFilteredHabits(), id: \.self) { habit in
                HabitGridButton(habit: habit, editingHabit: $editingHabit, timerEvent: $timerEvent, actionsFor: $showingActionsFor)
                    .contextMenu(menuItems: {
                        
                        Button(action: {
                            
                            showingNewLogSheet = true
                            
                        }, label: {
                            Text("Custom Log")
                        })
                        
                    })
                    
                    .drawingGroup()
                    
            }
        }
    }

    private var addButton: some View {
        
        
        Menu(content: {
            
       
            
            Divider()
            
            
            
        }, label: {
            Image(systemName: "plus")
        })
        
      /*  Button(action: { withAnimation(.smooth) { showNewHabitSheet.toggle() } }) {
        Image(systemName: "plus")
        } */
    }

    private var activeEvents: [Event] {
        events.filter { event in
            guard let habit = event.habit, habit.hasDuration && event.endDate == nil && event.habitHasDuration else { return false }
            if !habit.hasDuration {
                event.habitHasDuration = false
                try? context.save()
            }
            return true
        }.reversed()
    }

    private func getFilteredHabits() -> [Habit] {
        searchText.isEmpty ? Array(habits) : habits.filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
    }
    
    func getHabitSheetButtons(for habit: Habit) -> some View {
        
        Group {
            
            Button(action: {
                editingHabit = habit
            }, label: {
                Text("Edit Habit")
            })
            
            Button(action: {
                customLogHabit = habit
            }, label: {
                Text("Add Custom Log")
            })
            
            Button(action: {}, label: {
                Text("Option 3")
            })
            
        }
        
    }
    
    
}

// Preview
struct HabitGrid_Previews: PreviewProvider {
    static var previews: some View {
        HabitGrid()
    }
}

