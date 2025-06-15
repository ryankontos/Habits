//
//  HabitButton.swift
//  Habits
//
//  Created by Ryan on 12/12/2023.
//

import SwiftUI

struct HabitButton: View {
    var habit: Habit

    var body: some View {
        ZStack {
            HStack(spacing: 10) {
                Capsule()
                    .foregroundStyle(habit.color.gradient.opacity(0.9))
                    .overlay {
                        HStack {
                            HStack(spacing: 13) {
                                Image(systemName: habit.symbolName!)
                                    .font(.system(size: 26))
                                VStack(alignment: .leading) {
                                    Text(habit.name!)
                                        .fontWeight(.semibold)
                                    Text("Just Now")
                                }
                            }
                            .foregroundStyle(.white)
                            .shadow(radius: 10)
                            Spacer()
                            
                            Button(action: {
                                
                            }, label: {
                                Circle()
                                    .frame(height: 60)
                                    .foregroundStyle(habit.color.gradient.opacity(1))
                                    .shadow(radius: 6)
                                    .overlay {
                                        Image(systemName: "plus")
                                            .foregroundStyle(.white.opacity(0.9))
                                            .font(.system(size: 25))
                                            .fontWeight(.semibold)
                                            .opacity(1)
                                    }
                            })
                            .bouncyButton()
                            
                          
                        }
                        .padding(.leading, 25)
                        .padding(.trailing, 15)
                    }
                    .frame(height: 80)
            }
        }
    }
}


#Preview {
    HabitButton(habit: .previewHabit())
}

struct BouncyButtonModifier: ViewModifier {
    @State private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.bouncy, value: isPressed)
            .onLongPressGesture(
                minimumDuration: 0.1,
                pressing: { pressing in
                    withAnimation {
                        isPressed = pressing
                    }
                },
                perform: {}
            )
    }
}

extension View {
    func bouncyButton() -> some View {
        self.modifier(BouncyButtonModifier())
    }
}
