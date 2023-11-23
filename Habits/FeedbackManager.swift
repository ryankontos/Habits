//
//  FeedbackManager.swift
//  TimeSince
//
//  Created by Ryan on 15/11/2023.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

class FeedbackManager {
    
    enum NotificationFeedbackType {
        case success
        case error
        case warning
        
        #if os(iOS)
        
        func convert() -> UINotificationFeedbackGenerator.FeedbackType {
            switch self {
                
            case .success:
                return .success
            case .error:
                return .error
            case .warning:
                return .warning
            }
        }
        
        #endif
        
    }
    
    static var shared = FeedbackManager()
    
    #if os(iOS)

    private let notificationFeedback = UINotificationFeedbackGenerator()
    private let selectionFeedBack = UISelectionFeedbackGenerator()

    #endif
    
    func prepareForNotification() {
        
        #if os(iOS)
        notificationFeedback.prepare()
        #endif
        
    }
    
    func prepareForSelection() {
        
        #if os(iOS)
        selectionFeedBack.prepare()
        #endif
        
    }
    
    func selectionChanged() {
        
        #if os(iOS)
        
        selectionFeedBack.selectionChanged()
        
        #endif
        
    }
    
    func notificationOccurred(_ type: NotificationFeedbackType) {
        
        #if os(iOS)
        
        notificationFeedback.notificationOccurred(type.convert())
        
        #endif
        
    }
    
}
