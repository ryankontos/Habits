//
//  WidgetConfigurationAppINtent.swift
//  Habits
//
//  Created by Ryan on 21/11/2023.
//

import Foundation
import AppIntents


struct HabitsWidgetIntent: AppIntent, WidgetConfigurationIntent {
    static let intentClassName = "Configure Habits Widget"

    static var title: LocalizedStringResource = "Configure Habits Widget"
    static var description = IntentDescription("")

    @Parameter(title: "Habits", description: "Choose the Habits that appear in this widget." ,size: [.systemSmall: 1, .systemMedium: 4, .systemLarge: 10, .systemExtraLarge: 15, .accessoryInline: 1, .accessoryCorner: 1, .accessoryCircular: 1, .accessoryRectangular: 2])
    var habits: [HabitAppEntity]?

    
    @Parameter(title: "Show Active Timers", default: true)
    var showActiveTimer: Bool
    
    static var parameterSummary: some ParameterSummary {
        Summary {
            \.$habits
            \.$showActiveTimer
        }
    }

   /* static var predictionConfiguration: some IntentPredictionConfiguration {
        IntentPrediction(parameters: (\.$habits)) { parameter in
            DisplayRepresentation(
                title: "",
                subtitle: ""
            )
        }
    } */

    func perform() async throws -> some IntentResult {
        // TODO: Place your refactored intent handler code here.
        return .result()
    }
}
