//
//  SymbolsView.swift
//  Habits
//
//  Created by Ryan on 29/11/2023.
//

import SwiftUI


struct SymbolView: View {
    var habits: [Habit] // Array of SF Symbols

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<habits.count, id: \.self) { index in
                Image(systemName: habits[index].symbolName!)
                    .font(.habitsFont(size: 40))
                    .foregroundStyle(habits[index].color)
                    .position(positionFor(index: index, in: geometry.size))
            }
        }
    }

    private func positionFor(index: Int, in size: CGSize) -> CGPoint {
        let count = habits.count
        guard count > 1 else {
            // Center for a single symbol
            return CGPoint(x: size.width / 2, y: size.height / 2)
        }

        let angle = 2 * .pi / CGFloat(count) * CGFloat(index)
        let radius = min(size.width, size.height) / 3 // Adjust the radius as needed

        let x = size.width / 2 + radius * cos(angle)
        let y = size.height / 2 + radius * sin(angle)

        return CGPoint(x: x, y: y)
    }
}

