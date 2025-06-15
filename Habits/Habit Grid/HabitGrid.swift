import SwiftUI
import CoreData

struct HabitGrid: View {
    
    @Environment(\.managedObjectContext) private var context
    
    
    @FetchRequest(
        entity: Habit.entity(),
          sortDescriptors: [NSSortDescriptor(keyPath: \Habit.listOrder, ascending: true)]
    ) var habits: FetchedResults<Habit>

    
    var groupHabitOrdersFetchRequest: FetchRequest<GroupHabitOrder>
    
    var groupHabitOrders: FetchedResults<GroupHabitOrder> {
        groupHabitOrdersFetchRequest.wrappedValue
}
    
    @FetchRequest(fetchRequest: .init()) var events: FetchedResults<Event>
    
    @ObservedObject var state = HabitGridState()
    @State var editingGroup: HabitGroup?
    @Binding var mode: HabitGridMode
    
    init(mode: Binding<HabitGridMode>) {
        _mode = mode
        groupHabitOrdersFetchRequest = FetchRequest<GroupHabitOrder>(entity: GroupHabitOrder.entity(), sortDescriptors: [])
        setup(for: mode.wrappedValue)
    }

    let timerColumns = [GridItem(.adaptive(minimum: 400, maximum: 5000))]
    let columns = [GridItem(.adaptive(minimum: 400, maximum: 5000))]

    
    var body: some View {
        
        ZStack {
            
            
            AppBackground()
            
            
            Group {
                if !getHabits().isEmpty {
                    ScrollView {
                    Group {
                        habitEventsSection
                        habitGrid
                    }
                                        .padding(.horizontal)
                                            .padding(.top, 1)
                    }
                } else {
                        Text("No Habits")
                    }
            }
                        .plusToolbarButton {
                withAnimation(.smooth) { state.showNewHabitSheet.toggle() }
            }
            
        }
        
              .toolbar {
                  ToolbarItem(placement: .topBarLeading) {
                      Menu(content: {
                    HabitFilterMenu(mode: $mode, creatingNewGroup: $editingGroup)
                      }, label: {
                        Image(systemName: "line.3.horizontal.decrease.circle\(mode == .allHabits ? "" : ".fill")")
                    })
                  }

                  if state.group != nil {
                      ToolbarItem(placement: .topBarTrailing) {
        Menu(content: {
            Button(action: {
                state.showEditGroup = true
            }, label: {
                Image(systemName: "rectangle.grid.2x2.fill")
                Text("Manage Group Habits")
                })

            Button(action: {
                if let group = state.group {
                    editingGroup = group
                }
            }, label: {
                    Image(systemName: "pencil")
                    Text("Edit Group")
                })

            Button(role: .destructive, action: {
                withAnimation {
                if let group = state.group {
                        let context = PersistenceController.shared.container.viewContext
                        context.delete(group)
                        try? context.save()
                        self.mode = .allHabits
                    }
                }
            }, label: {
                    Image(systemName: "trash")
                Text("Delete Group")
                })
        }, label: {
            Image(systemName: "ellipsis.circle")
            })
    }
        }
        }
            .sheet(isPresented: $state.showEditGroup) {
            EditGroupHabitsView(group: state.group!)
            }
                .searchable(text: $state.searchText, placement: .navigationBarDrawer(displayMode: .always))
                .navigationTitle("\(state.group?.name ?? "All Habits")")
                .sheet(isPresented: $state.showNewHabitSheet) {
                    EditHabitView(group: self.state.group)
                }
          .sheet(item: $state.editingHabit) {
            EditHabitView($0, group: self.state.group)
        }
            .sheet(item: $state.timerEvent) {
            FullScreenActiveEventView(event: $0).environment(\.managedObjectContext, context)
        }
            .sheet(item: $state.customLogHabit) { habit in
                CustomLogView(habit: habit)
                            .presentationDetents([.medium])
            }
                .sheet(isPresented: $state.showReorder) {
                    HabitReorderView()
                }
              .sheet(item: $editingGroup) { group in
            EditGroupView(gridMode: $mode, existingGroup: group)
              }
                .onAppear {
#if canImport(ActivityKit)
            ActivityManager.updateActivities()
#endif
                }
    }


    func getHabits() -> [Habit] {
        if state.group == nil {
            // No group selected, return all habits
            return Array(habits)
        } else {
            // Group selected, return habits based on the GroupHabitOrder
            return groupHabitOrders.compactMap { $0.habit }
        }
    }
    
    private var habitEventsSection: some View {
        LazyVStack {
            if !events.isEmpty {
                LazyVGrid(columns: timerColumns, spacing: 10) {
                    Section {
                    ForEach(events) { event in
                        if let habit = event.habit {
                            Button(action: { state.timerEvent = event }) {
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
            HabitGridButton(habit: habit)
                  .environmentObject(state)
        }
    }

}

    private var addButton: some View {
        
        
        Menu(content: {
            
            
            
            Divider()
            
            
            
        }, label: {
                Image(systemName: "plus")
})
        
    
}

    

    private func getFilteredHabits() -> [Habit] {
        let habits = getHabits()
        return state.searchText.isEmpty ? Array(habits) : habits.filter { $0.name?.lowercased().contains(state.searchText.lowercased()) ?? false }
    }
    
    
    func getHabitSheetButtons(for habit: Habit) -> some View {
        
        Group {
            
            Button(action: {
                state.editingHabit = habit
            }, label: {
            Text("Edit Habit")
            })
            
            Button(action: {
                state.customLogHabit = habit
            }, label: {
                    Text("Add Custom Log")
            })
            
    Button(action: {}, label: {
        Text("Option 3")
    })
            
        }
        
    }
    
    
    mutating func setup(for mode: HabitGridMode) {
        
        
        
        switch mode {
        case .allHabits:
            
            groupHabitOrdersFetchRequest = FetchRequest<GroupHabitOrder>(entity: GroupHabitOrder.entity(), sortDescriptors: [])
            state.group = nil
        case .group(let group):
            
            
            groupHabitOrdersFetchRequest = FetchRequest<GroupHabitOrder>(
                entity: GroupHabitOrder.entity(),
                                 sortDescriptors: [NSSortDescriptor(keyPath: \GroupHabitOrder.order, ascending: true)],
                predicate: NSPredicate(format: "habitGroup == %@", group)
            )
            
            state.group = group
            
        }

        // Setup FetchRequest for habits
        _habits = FetchRequest<Habit>(
            sortDescriptors: [SortDescriptor(\.listOrder)],
                         predicate: HabitGrid.habitPredicate(group: state.group),
                         animation: .default
        )

        // Setup FetchRequest for events
        _events = FetchRequest<Event>(
            entity: Event.entity(),
                         sortDescriptors: [NSSortDescriptor(keyPath: \Event.startDate, ascending: true)],
            predicate: HabitGrid.eventPredicate(group: state.group),
                         animation: .bouncy
        )
        
        
        
    }
    
    private static func habitPredicate(group: HabitGroup?) -> NSPredicate {
        if let group = group {
            // Predicate for when group is non-nil
            return NSPredicate(format: "willDelete == %@ AND ANY groups == %@", NSNumber(value: false), group)
        } else {
            // Existing predicate for when group is nil
            return NSPredicate(format: "willDelete == %@", NSNumber(value: false))
        }
}

    private static func eventPredicate(group: HabitGroup?) -> NSPredicate {
        if let group = group {
            // Predicate for when group is non-nil
            return NSPredicate(format: "habit != nil AND habit.hasDuration == %@ AND endDate == nil AND habitHasDuration == %@ AND habit.willDelete == %@ AND ANY habit.groups == %@",
                         NSNumber(value: true),
                         NSNumber(value: true),
                         NSNumber(value: false),
                               group)
        } else {
            // Existing predicate for when group is nil
            return NSPredicate(format: "habit != nil AND habit.hasDuration == %@ AND endDate == nil AND habitHasDuration == %@ AND habit.willDelete == %@",
                               NSNumber(value: true),
                                 NSNumber(value: true),
                               NSNumber(value: false))
        }
    }
    
    enum HabitGridMode: Hashable {
        case allHabits
        case group(HabitGroup)
    }
    
}

// Preview


class HabitGridState: ObservableObject {
    
    @Published var searchText = ""
    @Published var showNewHabitSheet = false
    @Published var editingHabit: Habit?
    @Published var timerEvent: Event?
    
    @Published var customLogHabit: Habit?
    @Published var showReorder = false
    
    @Published var showEditGroup = false
    
    @Published var group: HabitGroup?
    
    
}
