//
//  Learnable.swift
//  Vocablo
//
//  Created by Marcel Jäger on 28.10.23.
//

import Foundation

protocol Learnable: AnyObject {
    var isLearnable: Bool { get set }
    var learningState: LearningState { get set }
    var learningContext: (word: String, sentence: String, translatedWord: String, translatedSentence: String) { get }
    var explenation: String { get }
}

extension Learnable {
    var currentLevel: LearningLevel {
        switch learningState {
        case .newly:
            return .min
        case .repeatly(_, _, let currentLevel):
            return currentLevel
        }
    }
    
    var downLevel: LearningLevel {
        switch learningState {
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
        switch learningState {
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
    
    func levelUp() {
        self.learningState = .repeatly(.now, learningState.repetitionCount + 1, nextLevel)
    }
    
    func levelDown() {
        self.learningState = .repeatly(.now, learningState.repetitionCount + 1, downLevel)
    }
}


