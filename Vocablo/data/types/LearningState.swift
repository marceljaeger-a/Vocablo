//
//  LearningState.swift
//  Vocablo
//
//  Created by Marcel Jäger on 28.10.23.
//

import Foundation

struct LearningState: Codable, Equatable, Hashable {
    var lastRepetition: Date?
    var level: LearningLevel = .lvl1
    var repetitionCount: Int = 0
    
    var isNewly: Bool {
        if lastRepetition == nil {
            return true
        }
        return false
    }
    
    var isRepeatly: Bool {
        if lastRepetition == nil {
            return false
        }
        return true
    }
    
    var nextRepetition: Date {
        guard let lastRepetition else { return .now }
        return lastRepetition + (Double(level.repeatingInterval) * 60)
    }
    
    var remainingSeconds: Int {
        Int(nextRepetition.timeIntervalSinceNow)
    }
    
    var remainingMinutes: Int {
        if remainingSeconds > 0 {
            return remainingSeconds / 60
        }
        return 0
    }

    var remainingHours: Int {
        if remainingMinutes > 0 {
            return remainingMinutes / 60
        }
        return 0
    }

    var remainingDays: Int {
        if remainingHours > 0 {
            return remainingHours / 24
        }
        return 0
    }

    var remainingTimeLabel: String {
        if remainingDays >= 1 {
            return "\(remainingDays) d"
        }else if remainingHours >= 1 {
            return "\(remainingHours) h"
        }else if remainingMinutes >= 1 {
            return "\(remainingMinutes) min"
        }
       return "\(remainingSeconds) sec"
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
        return level
    }

    var previousLevel: LearningLevel {
        return level.previousLevel() ?? .min
    }

    var nextLevel: LearningLevel {
        return level.nextLevel() ?? .max
    }

    mutating func repeatAndIncreaseLevel() {
        lastRepetition = .now
        level = nextLevel
        repetitionCount += 1
    }

    mutating func repeatAndDecreaseLevel() {
        lastRepetition = .now
        level = previousLevel
        repetitionCount += 1
    }

    mutating func reset() {
        lastRepetition = nil
        level = .lvl1
        repetitionCount = 0
    }
}

