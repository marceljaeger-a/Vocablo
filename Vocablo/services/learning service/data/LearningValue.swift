//
//  LearnSideValues.swift
//  Vocablo
//
//  Created by Marcel Jäger on 15.12.23.
//

import Foundation

@propertyWrapper
struct LearningValue<V: Learnable>: Identifiable {
    
    //MARK: - Types
    
    enum AskingLearningContent {
        case base, translation
    }
    
    //MARK: - Instanz Properties
    
    var value: V
    var askingContent: AskingLearningContent
    let id: UUID = UUID()
    
    ///Returns the wrapped instance of the Learnable conforming type.
    var wrappedValue: V {
        get {
            return value
        }
        set {
            value = newValue
        }
    }
    
    ///Returns the instance of that LearningValue.
    var projectedValue: LearningValue {
        self
    }

    ///Returns the primary content of the Learnable conforming instance based on which content is the asked content.
    var askingPrimaryContent: String {
        switch askingContent {
        case .base:
            value.basePrimaryContent
        case .translation:
            value.translationPrimaryContent
        }
    }

    ///Returns the secondary content of the Learnable conforming instance based on which content is the asked content.
    var askingSecondaryContent: String {
        switch askingContent {
        case .base:
            value.baseSecondaryContent
        case .translation:
            value.translationSecondaryContent
        }
    }

    ///Returns the primary content of the Learnable conforming instance based on which content is the answered content.
    var answeringPrimaryContent: String {
        switch askingContent {
        case .base:
            value.translationPrimaryContent
        case .translation:
            value.basePrimaryContent
        }
    }

    ///Returns the secondary content of the Learnable conforming instance based on which content is the answered content.
    var answeringSecondaryContent: String {
        switch askingContent {
        case .base:
            value.translationSecondaryContent
        case .translation:
            value.baseSecondaryContent
        }
    }
    
    ///Returns the learning state of the asked content.
    var askingState: LearningState {
        get {
            switch askingContent {
            case .base:
                value.baseState
            case .translation:
                value.translationState
            }
        }
    }
    
    //MARK: Instanz Methodes
    
    ///Increases the level of the asked learning state, if is not already the maximum.
    func answerTrue() {
        switch askingContent {
        case .base:
            value.baseState.repeatAndIncreaseLevel()
        case .translation:
            value.translationState.repeatAndIncreaseLevel()
        }
    }
    
    ///Decrease the level of the asked learning state, if it is not already the minimum.
    func answerFalse() {
        switch askingContent {
        case .base:
            value.baseState.repeatAndDecreaseLevel()
        case .translation:
            value.translationState.repeatAndDecreaseLevel()
        }
    }
}

extension LearningValue: Equatable {
    static func ==(lhs: LearningValue, rhs: LearningValue) -> Bool {
        lhs.id == rhs.id
    }
}
