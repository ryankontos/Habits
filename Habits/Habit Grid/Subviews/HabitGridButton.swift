// HabitGridButton.swift
// TimeSince
// Created by Ryan on 13/11/2023.

import SwiftUI
#if canImport(ActivityKit)
import ActivityKit
#endif
import CoreData

struct HabitGridButton: View {
    enum InfoButtonState {
        case idle, adding, done, undo, undoing
        
    }
    
    @State private var contextChangesObserver: Any?
    
    var habit: Habit
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var colorScheme
    @State private var internalState: InfoButtonState = .idle
  
    @State var lastCreatedEvent: Event?
    
    @State var showDelete: Bool = false
    
    @FetchRequest
    private var events: FetchedResults<Event>
    
    @EnvironmentObject var gridState: HabitGridState
    
    init(habit: Habit) {
        
       
      
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
        request.predicate = NSPredicate(format: "habit == %@ AND isCancelled == %@", habit, NSNumber(value: false))
        request.fetchLimit = 1
        
        _events = FetchRequest(fetchRequest: request, animation: .easeInOut)
       
        self.habit = habit
        
        
        
    }
    
    var state: InfoButtonState {
        
        get {
            return internalState
        }
        
        set (new) {
            self.internalState = new
        }
        
    }
    
    var body: some View {
        
        
        
        Button(action: onMainTap) {
            if habit.isDeleted {
                 EmptyView()
            } else {
                
                buttonContent()
                    
                    .contentShape(.contextMenuPreview,RoundedRectangle(cornerRadius: 25.0))
                    .contextMenu {
                        buttonContextMenu()
                        
                        
                    }
                    .onAppear() {
                       
                        setupContextObserver()
                    }
                    .onAppear() {
                        if lastCreatedEvent?.managedObjectContext == nil {
                            lastCreatedEvent = nil
                        }
                    }
                    //.disabled(state != .idle)
                    .contentShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                    .deleteHabitAlert(showAlert: $showDelete, habit: habit, dismissAfterDelete: false)
                    
            }
               
                
            
        }
        .bouncyButton()
        .drawingGroup()
       
    }

    private func onMainTap() {
        
        if state != .idle {
            return
        }
        
        withAnimation {
            internalState = .adding
        }
        
        FeedbackManager.shared.selectionChanged()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            FeedbackManager.shared.notificationOccurred(.success)
            let event = saveNewEvent()

            self.scheduleTask(interval: 0, forLastCreatedID: event.objectID) {
                internalState = .done
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.scheduleTask(interval: 0, forLastCreatedID: event.objectID) {
                    internalState = .undo
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.scheduleTask(interval: 0, forLastCreatedID: event.objectID) {
                        internalState = .idle
                    }
                    
                   
                }
               
            }
            
            
        }
    }
    
    func scheduleTask(interval: Double, forLastCreatedID id: NSManagedObjectID?, action: @escaping ( () -> Void)) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            
            if id == nil || self.lastCreatedEvent?.objectID == id {
                
                withAnimation {
                    action()
                }
                
            } else {
                internalState = .idle
            }
            
        }
        
    }

    private func saveNewEvent() -> Event {
        
       
        let event = habit.createNewEvent()
        lastCreatedEvent = event
        if event.habitHasDuration {
         
            
            #if canImport(ActivityKit)
            ActivityManager.updateActivities()
            #endif
            
        }
        
        return event
        
    }

    private func buttonContent() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .frame(height: 120)
                .foregroundStyle(habit.color)
                //.shadow(radius: 4)
                .brightness(colorScheme == .dark ? -0.1 : 0)
               
               // .opacity(0.8)
                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    topRowContent
                    Spacer()
                    habitInfoContent
                }
                .foregroundColor(.white)
                .padding(.vertical, 16)

                Spacer()
            }
        
           // .drawingGroup(opaque: false)
            .padding(.leading, 15)
            .padding(.trailing, 10)
        }
      
    }

    private var topRowContent: some View {
        HStack {
            Image(systemName: habit.symbolName ?? "")
                .frame(height: 20)
                .font(.habitsFont(size: 22))
            
            Spacer()
            
            Button(action: {
                
                if let lastCreatedEvent = lastCreatedEvent, state == .undo {
                    performUndo(lastCreatedEvent)
                   
                } else {
                    gridState.editingHabit = habit
                }
                
            }) {
                infoButtonContent
            }
            .hoverEffect(.lift)
            .scaleEffect([InfoButtonState.done, .undo].contains(state) ? 1.25 : 1.0)
            .disabled([InfoButtonState.adding, .undoing, .done].contains(state))
            .frame(height: 30)
           
        }
    }
    
    func performUndo(_ event: Event) {
        
        
        FeedbackManager.shared.selectionChanged()
        
        withAnimation(.default) {
            
            internalState = .idle
           
        }
        
        event.delete(cancelFirst: true)
        self.lastCreatedEvent = nil
        
    }

    private var habitInfoContent: some View {
        VStack(alignment: .leading, spacing: 2) {
            
            HStack(spacing: 4) {
                
                if habit.hasDuration {
                    
                    Image(systemName: "stopwatch")
                        .foregroundStyle(.white)
                        .font(.habitsFont(size: 15))
                        .fontWeight(.semibold)
                    
                }
                
                Text(habit.name ?? "")
                    .lineLimit(1)
                    .font(.habitsFont(size: 18))
                    .fontWeight(.semibold)
                
            }

            TimelineView(.periodic(from: Date(), by: 1)) { date in
                Text(getHabitInfoString(at: date.date))
                    .lineLimit(1)
                    .opacity(0.8)
            }
            
           
        }
       
    }

    private var infoButtonContent: some View {
        ZStack {
            Circle()
                .foregroundStyle(.white.opacity(0.2))
                
            Circle()
                .trim(from: 0, to: [InfoButtonState.adding].contains(state) ? 1.0 : 0.0)
                .stroke(Color.white, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .transaction { $0.animation = [InfoButtonState.done, .idle].contains(state) ? nil : .default }

            stateImage
                .transaction { $0.animation = [InfoButtonState.idle, .done].contains(state) ? nil : .default }

        }
        
       // .drawingGroup()
    }

    private var stateImage: some View {
        Group {
            switch state {
            case .idle: Image(systemName: "ellipsis").fontWeight(.black)
            case .adding: EmptyView()
            case .done: HStack {
                Image(systemName: "checkmark").fontWeight(.semibold)
            }
            
            case .undo:
                Image(systemName: "arrow.uturn.backward").fontWeight(.semibold)
            case .undoing:
                Image(systemName: "ellipsis").fontWeight(.black)
            }
        }
        .foregroundStyle(.white)
    }

    private func getHabitInfoString(at date: Date) -> String {
        
        if state == .adding {
            return habit.hasDuration ? "Starting Timer..." : "Logging..."
        }
        
        
        if state == .undoing {
            return habit.hasDuration ? "Stopping Timer..." : "Undoing..."
        }
        
        
        guard let latest = events.first else {
         
            return "Never Logged"
        }
        
       
        

        if latest != lastCreatedEvent {
            return formatRelativeTime(since: latest.endDate ?? latest.startDate ?? Date(), now: date)
        }

        if latest.habitHasDuration && habit.hasDuration && latest.endDate == nil {
            return "Timer Active"
        }

        return formatRelativeTime(since: latest.endDate ?? latest.startDate ?? Date(), now: date)
        
    }


    func formatRelativeTime(since date: Date, now: Date = Date()) -> String {
        let calendar = Calendar.current

        let minuteComponents: Set<Calendar.Component> = [.minute]
        guard let minutes = calendar.dateComponents(minuteComponents, from: date, to: now).minute else {
            return "Error" // or handle error appropriately
        }

        
        let hours = minutes / 60
        let days = hours / 24
        

        if days > 3 {
            return "\(days) \(days == 1 ? "day" : "days") ago"
        } else if minutes >= 60 {
            return "\(hours) \(hours == 1 ? "hour" : "hours") ago"
        } else if minutes >= 1 {
            return "\(minutes) \(minutes == 1 ? "minute" : "minutes") ago"
        } else {
            return "Just Now"
        }
    }

    
    private func setupContextObserver() {
            contextChangesObserver = NotificationCenter.default.addObserver(
                forName: .NSManagedObjectContextObjectsDidChange,
                object: context,
                queue: nil
            ) { _ in

                if lastCreatedEvent != nil && (lastCreatedEvent!.managedObjectContext == nil || lastCreatedEvent!.isCancelled) {
                    self.handleEventDeletion()
                }
            }
        }
    
    private func handleEventDeletion() {
            // Update state as required
            withAnimation {
                
                if internalState != .undoing {
                    internalState = .idle
                }
                
                
            }
            lastCreatedEvent = nil
    }
    
    @ViewBuilder
    func buttonContextMenu() -> some View {
        
        Group {
            
            Section("Log") {
                
                Button(action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                        onMainTap()
                    }
                }, label: {
                    Image(systemName: "plus")
                    Text("Now")
                })
                
                Button(action: {
                    
                    gridState.customLogHabit = habit
                    
                }, label: {
                    Image(systemName: "calendar.badge.plus")
                    Text("Custom Date")
                })
                
            }
            
            Divider()
            
            if let group = gridState.group {
                
                Button(action: {
                    
                    gridState.showEditGroup = true
                    
                   
                    
                }, label: {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Manage Group Habits")
                })
                
            } else {
                
                Button(action: {
                    
                    gridState.showReorder = true
                    
                   
                    
                }, label: {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Rearrange Habits")
                })
                
            }
            
         
            
            Divider()
            
            Button(action: {
                
                gridState.editingHabit = habit
                
               
                
            }, label: {
                Image(systemName: "pencil")
                Text("Edit Habit")
            })
            
            Button(role: .destructive, action: {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showDelete = true
                }
                
            }, label: {
                Image(systemName: "trash")
                Text("Delete Habit")
            })
            
        }
        
    }
    
}
