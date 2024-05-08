//
//  LearningState.swift
//  Vocablo
//
//  Created by Marcel Jäger on 28.10.23.
//

import Foundation
//
//struct LearningState: Codable, Equatable, Hashable {
//    var repetitions: Array<Date> = []
//    var level: LearningLevel = .lvl1
//    
//    var repetitionCount: Int {
//        repetitions.count
//    }
//    
//    var lastRepetition: Date? {
//        get {
//            repetitions.last
//        }
//        set(newDate){
//            if let newDate {
//                if repetitions.isEmpty {
//                    repetitions.append(newDate)
//                } else {
//                    repetitions[repetitionCount - 1] = newDate
//                }
//            }else {
//                repetitions.removeLast()
//            }
//        }
//    }
//    
//    var isNewly: Bool {
//        if repetitions.isEmpty {
//            return true
//        }
//        return false
//    }
//    
//    var isRepeatly: Bool {
//        if repetitions.isEmpty {
//            return false
//        }
//        return true
//    }
//    
//    var nextRepetition: Date {
//        guard let lastRepetition else { return .now }
//        return lastRepetition + (Double(level.repeatingInterval) * 60)
//    }
//    
//    var remainingSeconds: Int {
//        Int(nextRepetition.timeIntervalSinceNow)
//    }
//    
//    var remainingMinutes: Int {
//        return remainingSeconds / 60
//    }
//
//    var remainingHours: Int {
//        return remainingMinutes / 60
//    }
//
//    var remainingDays: Int {
//        return remainingHours / 24
//    }
//
//    var remainingTimeLabel: String {
//        if remainingDays >= 1 {
//            return "\(remainingDays) d"
//        }else if remainingHours >= 1 {
//            return "\(remainingHours) h"
//        }else if remainingMinutes >= 1 {
//            return "\(remainingMinutes) min"
//        }else if remainingSeconds >= 1 {
//            return "\(remainingSeconds) sec"
//        }
//        return "0 sec"
//    }
//    
//    var isNextRepetitionExpired: Bool {
//        let todayZeroDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: .now)
//        let nextRepetititonZeroDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: nextRepetition)
//
//        guard let todayZeroDate else { return false }
//        guard let nextRepetititonZeroDate else { return false }
//
//        if nextRepetititonZeroDate <= todayZeroDate {
//            return true
//        }
//        return false
//    }
//}
//
//extension LearningState {
//    var currentLevel: LearningLevel {
//        return level
//    }
//
//    var previousLevel: LearningLevel {
//        return level.previousLevel() ?? .min
//    }
//
//    var nextLevel: LearningLevel {
//        return level.nextLevel() ?? .max
//    }
//
//    mutating func repeatAndIncreaseLevel() {
//        repetitions.append(.now)
//        level = nextLevel
//    }
//
//    mutating func repeatAndDecreaseLevel() {
//        repetitions.append(.now)
//        level = previousLevel
//    }
//
//    mutating func reset() {
//        repetitions = []
//        level = .lvl1
//    }
//}

