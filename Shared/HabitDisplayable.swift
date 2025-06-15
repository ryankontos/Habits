//
//  HabitDisplayable.swift
//  Habits
//
//  Created by Ryan on 14/12/2023.
//

import Foundation
import SwiftUI

protocol HabitDisplayable {
    
    var name: String? { get }
    var symbolName: String? { get }
    var serializedColor: SerializableColor? { get }
    
}
