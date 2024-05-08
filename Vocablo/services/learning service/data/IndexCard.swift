//
//  LearnSideValues.swift
//  Vocablo
//
//  Created by Marcel Jäger on 15.12.23.
//

import Foundation

@propertyWrapper
struct IndexCard<V: Learnable>: Identifiable {
    
    //MARK: - Types
    
    enum Side {
        case front, back
    }
    
    //MARK: - Instanz Properties
    
    var value: V
    var askingSide: Side
    let id: UUID = UUID()
    
    var wrappedValue: V {
        get {
            return value
        }
        set {
            value = newValue
        }
    }
    
    var projectedValue: IndexCard {
        self
    }
    
    var isNew: Bool {
        switch askingSide {
        case .front:
            value.sessionsOfFront.isEmpty
        case .back:
            value.sessionsOfBack.isEmpty
        }
    }

    var askingPrimaryContent: String {
        switch askingSide {
        case .front:
            value.primaryContentOfFront
        case .back:
            value.primaryContentOfBack
        }
    }

    var askingSecondaryContent: String {
        switch askingSide {
        case .front:
            value.secondaryContentOfFront
        case .back:
            value.secondaryContentOfBack
        }
    }

    var answeringPrimaryContent: String {
        switch askingSide {
        case .front:
            value.primaryContentOfBack
        case .back:
            value.primaryContentOfFront
        }
    }
    
    var answeringSecondaryContent: String {
        switch askingSide {
        case .front:
            value.secondaryContentOfBack
        case .back:
            value.secondaryContentOfFront
        }
    }
    
    var askingLevel: LearningLevel {
        switch askingSide {
        case .front:
            value.levelOfFront
        case .back:
            value.levelOfBack
        }
    }
    
    //MARK: Instanz Methodes

    func answerTrue() {
        value.answerTrue(askingSide: self.askingSide)
    }
    
    func answerWrong() {
        value.answerWrong(askingSide: self.askingSide)
    }
}

extension IndexCard: Equatable {
    static func ==(lhs: IndexCard, rhs: IndexCard) -> Bool {
        lhs.id == rhs.id
    }
}
