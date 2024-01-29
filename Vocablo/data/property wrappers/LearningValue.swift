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
    
    enum AskingLearningContent {
        case base, translation
    }
    
    //MARK: - Instanz Properties
    
    var learnableObject: Learnable
    var asking: AskingLearningContent
    
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
    
    ///Returns the wrapped Learnable instanz´s word property, when the asking learning content is base.
    ///Returns the wrapped Learnable instanz´s translatedWord propeerty, when the asking learning content is translation.
    var askingWord: String {
        switch asking {
        case .base:
            learnableObject.baseWord
        case .translation:
            learnableObject.translationWord
        }
    }
    
    ///Returns the wrapped Learnable instanz´s sentence property, when the asking learning content is base.
    ///Returns the wrapped Learnable instanz´s translatedSentence property, when the asking learning content is translation.
    var askingSentence: String {
        switch asking {
        case .base:
            learnableObject.baseSentence
        case .translation:
            learnableObject.translationSentence
        }
    }
    
    ///Returns the wrapped Learnable instanz´s word property for the answer, when the asking learning content is translation.
    ///Returns the wrapped Learnable instanz´s translatedWord property for the answer, when the asking learning content is base.
    var answeringWord: String {
        switch asking {
        case .base:
            learnableObject.translationWord
        case .translation:
            learnableObject.baseWord
        }
    }
    
    ///Returns the wrapped Learnable instanz´s word sentence for the answer, when the asking learning content is translation.
    ///Returns the wrapped Learnable instanz´s translatedSentence property for the answer, when the asking learning content is base.
    var answeringSentence: String {
        switch asking {
        case .base:
            learnableObject.translationSentence
        case .translation:
            learnableObject.baseSentence
        }
    }
    
    ///Returns the wrapped Learnable instanz´s learningState property, when the asking learning content is base.
    ///Returns the wrapped Learnable instanz´s translatedLearningState property , when the asking learning content is translation.
    var askingState: LearningState {
        get {
            switch asking {
            case .base:
                learnableObject.baseState
            case .translation:
                learnableObject.translationState
            }
        }
    }
    
    ///Returns the repeatIntervalLabel of the nextLevel of the current return value of the asking state.
    var nextLevelRepeatingIntervalLabel: String {
        askingState.nextLevel.repeatingIntervalLabel
    }
    
    ///Returns the repeatIntervalLabel of the previousLevell of the current return value of the asking state.
    var previousLevelRepeatingIntervalLabel: String {
        askingState.previousLevel.repeatingIntervalLabel
    }
    
    //MARK: Instanz Methodes
    
    ///Increase the level of the current return value of the asking state.
    func answerTrue() {
//        let oldValue = askingState
        
        switch asking {
        case .base:
            learnableObject.baseState.repeatAndIncreaseLevel()
        case .translation:
            learnableObject.translationState.repeatAndIncreaseLevel()
        }
        
//        let newValue = askingState
        
//        if let vocabulary = learnableObject as? Vocabulary {
//            if let context = vocabulary.modelContext {
//                if let undoManager = context.undoManager {
//                    undoManager.registerUndo(withTarget: vocabulary) { undoVocabulary in
//                        switch asking {
//                        case .base:
//                            learnableObject.baseState = oldValue
//                        case .translation:
//                            learnableObject.translationState = oldValue
//                        }
//                        
//                        undoManager.registerUndo(withTarget: undoVocabulary) { redoVocabulary in
//                            answerTrue()
//                        }
//                    }
//                }
//            }
//        }
    }
    
    ///Decrease the level of the current return value of the asking.
    func answerFalse() {
//        let oldValue = askingState
        
        switch asking {
        case .base:
            learnableObject.baseState.repeatAndDecreaseLevel()
        case .translation:
            learnableObject.translationState.repeatAndDecreaseLevel()
        }
        
//        let newValue = askingState
        
//        if let vocabulary = learnableObject as? Vocabulary {
//            if let context = vocabulary.modelContext {
//                if let undoManager = context.undoManager {
//                    undoManager.registerUndo(withTarget: vocabulary) { undoVocabulary in
//                        switch asking {
//                        case .base:
//                            learnableObject.baseState = oldValue
//                        case .translation:
//                            learnableObject.translationState = oldValue
//                        }
//                        
//                        undoManager.registerUndo(withTarget: undoVocabulary) { redoVocabulary in
//                            answerFalse()
//                        }
//                    }
//                }
//            }
//        }
    }
}
