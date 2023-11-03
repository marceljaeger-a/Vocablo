//
//  LearningState.swift
//  Vocablo
//
//  Created by Marcel Jäger on 28.10.23.
//

import Foundation

enum LearningState: Codable, Equatable {
    case newly(LearningLevel)   //LearningLevel
    case repeatly(Date, Int, LearningLevel) //Last repetition, Count of repetitions, current level
    
    var isNewly: Bool {
        switch self {
        case .newly(_): return true
        case .repeatly(_, _, _): return false
        }
    }
    
    var isRepeatly: Bool {
        switch self {
        case .newly(_): return false
        case .repeatly(_, _, _): return true
        }
    }
    
    var lastRepetition: Date? {
        switch self {
        case .newly(_):
            return nil
        case let .repeatly(repetitionDate, _, _):
            return repetitionDate
        }
    }
    
    var nextRepetition: Date {
        switch self {
        case .newly(_):
            return .now
        case let .repeatly(lastRepetition, _, level):
            return lastRepetition + (Double(level.repeatInterval) * 60)
        }
    }
    
    var repetitionCount: Int {
        switch self {
        case .newly(_):
            return 0
        case let .repeatly(_, count, _):
            return count
        }
    }
    
    var remainingMinutes: Int {
        switch self {
        case .newly(_):
            return 0
        case .repeatly(_, _, _):
            if Date.now >= nextRepetition {
                return 0
            }else {
                return Int(nextRepetition.timeIntervalSinceNow / 60)
            }
        }
    }
    
    var remainingHours: Int {
        remainingMinutes / 60
    }
    
    var remainingDays: Int {
        remainingHours / 24
    }
    
    var remainingTimeLabel: String {
        if remainingDays >= 1 {
            return "\(remainingDays) d"
        }else if remainingHours >= 1 {
            return "\(remainingHours) h"
        }
        return "\(remainingMinutes) min"
    }
}
