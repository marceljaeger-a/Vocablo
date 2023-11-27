//
//  LearningState.swift
//  Vocablo
//
//  Created by Marcel Jäger on 28.10.23.
//

import Foundation

enum LearningState: Codable, Equatable{
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
    
    var isNextRepetitionExpired: Bool {
        let todayZeroDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: .now)
        let nextRepetititonZeroDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: nextRepetition)
        
        guard let todayZeroDate else { return false }
        guard let nextRepetititonZeroDate else { return false }
        
        if nextRepetititonZeroDate <= todayZeroDate {
            return true
        }
        return false
    }
}

extension LearningState {
    var currentLevel: LearningLevel {
        switch self {
        case .newly(let currentLevel):
            return currentLevel
        case .repeatly(_, _, let currentLevel):
            return currentLevel
        }
    }
    
    var downLevel: LearningLevel {
        switch self {
        case .newly:
            return .min
        case .repeatly(_, _, let currentLevel):
            if let downLevel = currentLevel.downLevel() {
                return downLevel
            }else {
                return .min
            }
        }
    }
    
    var nextLevel: LearningLevel {
        switch self {
        case .newly:
            return .lvl2
        case let .repeatly(_, _, currentLevel):
            if let nextLevel = currentLevel.nextLevel() {
                return nextLevel
            }else {
                return .max
            }
        }
    }
    
    mutating func levelUp() {
        self = .repeatly(.now, self.repetitionCount + 1, nextLevel)
    }
    
    mutating func levelDown() {
        self = .repeatly(.now, self.repetitionCount + 1, downLevel)
    }
    
    mutating func reset() {
        self = .newly(.lvl1)
    }
}

extension LearningState: Hashable {
    
}
