//
//  LearnSideValues.swift
//  Vocablo
//
//  Created by Marcel Jäger on 15.12.23.
//

import Foundation

@propertyWrapper
struct LearningValue {
    
    //MARK: - Types
    
    enum AskedWord {
        case word, translatedWord
    }
    
    //MARK: - Instanz Properties
    
    var learnableObject: Learnable
    var asking: AskedWord
    
    ///Returns the wrapped Learnable instanz.
    var wrappedValue: Learnable {
        get {
            return learnableObject
        }
        set {
            learnableObject = newValue
        }
    }
    
    ///Returns the self LearningValues instanz.
    var projectedValue: LearningValue {
        self
    }
    
    ///Returns the wrapped Learnable instanz´s word property, when the asking property is word.
    ///Returns the wrapped Learnable instanz´s translatedWord propeerty, when the asking property is translatedWord.
    var askedWord: String {
        switch asking {
        case .word:
            learnableObject.word
        case .translatedWord:
            learnableObject.translatedWord
        }
    }
    
    ///Returns the wrapped Learnable instanz´s sentence property, when the asking property is word.
    ///Returns the wrapped Learnable instanz´s translatedSentence property, when the asking property is translatedWord.
    var askedSentence: String {
        switch asking {
        case .word:
            learnableObject.sentence
        case .translatedWord:
            learnableObject.translatedSentence
        }
    }
    
    ///Returns the wrapped Learnable instanz´s word property for the answer, when the asking property is translatedWord.
    ///Returns the wrapped Learnable instanz´s translatedWord property for the answer, when the asking property is word.
    var answeredWord: String {
        switch asking {
        case .word:
            learnableObject.translatedWord
        case .translatedWord:
            learnableObject.word
        }
    }
    
    ///Returns the wrapped Learnable instanz´s word sentence for the answer, when the asking property is translatedWord.
    ///Returns the wrapped Learnable instanz´s translatedSentence property for the answer, when the asking property is word.
    var answeredSentence: String {
        switch asking {
        case .word:
            learnableObject.translatedSentence
        case .translatedWord:
            learnableObject.sentence
        }
    }
    
    ///Returns the wrapped Learnable instanz´s learningState property, when the asking property is word.
    ///Returns the wrapped Learnable instanz´s translatedLearningState property , when the asking property is translatedWord.
    var state: LearningState {
        get {
            switch asking {
            case .word:
                learnableObject.learningState
            case .translatedWord:
                learnableObject.translatedLearningState
            }
        }
    }
    
    ///Returns the repeatIntervalLabel of the nextLevel of the current return value of the state property.
    var nextRepeatIntervalLabel: String {
        state.nextLevel.repeatIntervalLabel
    }
    
    ///Returns the repeatIntervalLabel of the previousLevell of the current return value of the state property.
    var previousRepeatIntervalLabel: String {
        state.previousLevel.repeatIntervalLabel
    }
    
    //MARK: Instanz Methodes
    
    ///Increase the level of the current return value of the state property.
    func answerTrue() {
        switch asking {
        case .word:
            learnableObject.learningState.increaseLevel()
        case .translatedWord:
            learnableObject.translatedLearningState.increaseLevel()
        }
    }
    
    ///Decrease the level of the current return value of the state property.
    func answerFalse() {
        switch asking {
        case .word:
            learnableObject.learningState.decreaseLevel()
        case .translatedWord:
            learnableObject.translatedLearningState.decreaseLevel()
        }
    }
}
