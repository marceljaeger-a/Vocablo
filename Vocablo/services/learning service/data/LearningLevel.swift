//
//  LearningLevel.swift
//  Vocablo
//
//  Created by Marcel Jäger on 30.10.23.
//

import Foundation

enum LearningLevel: String, Codable, CaseIterable {
    typealias Minutes = Int
    
    //MARK: - Cases (Levels)
    
    case lvl1 = "Level 1"
    case lvl2 = "Level 2"
    case lvl3 = "Level 3"
    case lvl4 = "Level 4"
    case lvl5 = "Level 5"
    case lvl6 = "Level 6"
    case lvl7 = "Level 7"
    case lvl8 = "Level 8"
    case lvl9 = "Level 9"
    case lvl10 = "Level 10"
    case lvl11 = "Level 11"
    case lvl12 = "Level 12"
    case lvl13 = "Level 13"
    case lvl14 = "Level 14"
    case lvl15 = "Level 15"
    
    //MARK: - Type Properties
    
    ///Returns the lowest LearningLevel.
    static var min: Self {
        .lvl1
    }
    
    ///Return the highest LearningLevel.
    static var max: Self {
        .lvl15
    }
    
    //MARK: - Instanz Properties

    ///Returns the duration between the last repetition and the next repetition.
    var repeatingInterval: Minutes {
        switch self {
        case .lvl1:
            1
        case .lvl2:
            10
        case .lvl3:
            24*60*1
        case .lvl4:
            24*60*3
        case .lvl5:
            24*60*6
        case .lvl6:
            24*60*10
        case .lvl7:
            24*60*15
        case .lvl8:
            24*60*21
        case .lvl9:
            24*60*28
        case .lvl10:
            24*60*36
        case .lvl11:
            24*60*45
        case .lvl12:
            24*60*55
        case .lvl13:
            24*60*66
        case .lvl14:
            24*60*78
        case .lvl15:
            24*60*91
        }
    }
    
    ///Returns a calculated String label for the current duration between the last repetition and the next repetition.
    var repeatingIntervalLabel: String {
       switch self.repeatingInterval {
       case 0..<60:
           return "\(self.repeatingInterval)min"
       case 60..<(60*24):
           return "\(self.repeatingInterval / 60)h"
       default:
           return "\((self.repeatingInterval / 60) / 24)d"
       }
   }
    
    //MARK: - Instanz Methodes
    
    ///Returns the next level.
    ///Returns nil when the level is the highest.
    func nextLevel() -> Self? {
        let currentIndex = Self.allCases.firstIndex(of: self)
        guard let currentIndex else { return nil }
        let nextIndex = currentIndex + 1
        guard Self.allCases.count > nextIndex  else { return nil }
        return Self.allCases[nextIndex]
    }
    
    ///Returns the previous level.
    ///Returns niil when the current level is the lowest.
    func previousLevel() -> Self? {
        switch self {
        case .lvl1: return nil
        case .lvl2: return .lvl1
        default: return .lvl2
        }
    }
}
