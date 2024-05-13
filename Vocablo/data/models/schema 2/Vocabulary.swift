//
//  Vocabulary.swift
//  Vocablo
//
//  Created by Marcel Jäger on 06.05.24.
//

import Foundation
import SwiftData
import SwiftUI

@Model final class Vocabulary {
    var baseWord: String
    var baseSentence: String
    var translationWord: String
    var translationSentence: String
    var isToLearn: Bool
    var levelOfBase: LearningLevel
    var levelOfTranslation: LearningLevel
    var sessionsOfBase: Array<Date>
    var sessionsOfTranslation: Array<Date>
    var nextSessionOfBase: Date
    var nextSessionOfTranslation: Date
    
    let created: Date = Date.now
    @Relationship() var deck: Deck? = nil
    
    //MARK: - Initialiser
    
    init(
        baseWord: String,
        baseSentence: String,
        translationWord: String,
        translationSentence: String,
        isToLearn: Bool,
        levelOfBase: LearningLevel,
        levelOfTranslation: LearningLevel,
        sessionsOfBase: Array<Date>,
        sessionsOfTranslation: Array<Date>,
        nextSessionOfBase: Date,
        nextSessionOfTranslation: Date,
        deck: Deck? = nil
    ) {
        self.baseWord = baseWord
        self.baseSentence = baseSentence
        self.translationWord = translationWord
        self.translationSentence = translationSentence
        self.isToLearn = isToLearn
        self.levelOfBase = levelOfBase
        self.levelOfTranslation = levelOfTranslation
        self.sessionsOfBase = sessionsOfBase
        self.sessionsOfTranslation = sessionsOfTranslation
        self.nextSessionOfBase = nextSessionOfBase
        self.nextSessionOfTranslation = nextSessionOfTranslation
        self.deck = deck
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.baseWord = try container.decode(String.self, forKey: .baseWord)
        self.translationWord = try container.decode(String.self, forKey: .translationWord)
        self.baseSentence = try container.decode(String.self, forKey: .baseSentence)
        self.translationSentence = try container.decode(String.self, forKey: .translationSentence)
        self.isToLearn = try container.decode(Bool.self, forKey: .isToLearn)
        self.levelOfBase = try container.decode(LearningLevel.self, forKey: .levelOfBase)
        self.levelOfTranslation = try container.decode(LearningLevel.self, forKey: .levelOfTranslation)
        self.sessionsOfBase = try container.decode(Array<Date>.self, forKey: .sessionsOfBase)
        self.sessionsOfTranslation = try container.decode(Array<Date>.self, forKey: .sessionsOfTranslation)
        self.nextSessionOfBase = try container.decode(Date.self, forKey: .nextSessionOfBase)
        self.nextSessionOfTranslation = try container.decode(Date.self, forKey: .nextSessionOfTranslation)
    }
    
    required init(copyOf value: Vocabulary) {
        self.baseWord = value.baseWord
        self.translationWord = value.translationWord
        self.baseSentence = value.baseSentence
        self.translationSentence = value.translationSentence
        self.isToLearn = value.isToLearn
        self.levelOfBase = value.levelOfBase
        self.levelOfTranslation = value.levelOfTranslation
        self.sessionsOfBase = value.sessionsOfBase
        self.sessionsOfTranslation = value.sessionsOfTranslation
        self.nextSessionOfBase = value.nextSessionOfBase
        self.nextSessionOfTranslation = value.nextSessionOfTranslation
    }
    
    //MARK: - Methods
    
    ///Removes that vocabulary from the deck.
    ///
    ///> If you set the property to nil without this methode, the UndoManager will not be able to register the unrelating!
    func removeFromDeck() {
        if let deck {
            deck.remove(vocabulary: self)
        }
    }
    
    func reset() {
        self.levelOfBase = .lvl1
        self.levelOfTranslation = .lvl1
        self.sessionsOfBase = []
        self.sessionsOfTranslation = []
        self.nextSessionOfBase = Date.now
        self.nextSessionOfTranslation = Date.now
    }
}

extension Vocabulary: Codable, Transferable, Copyable {
    enum CodingKeys: CodingKey {
        case baseWord, baseSentence, translationWord, translationSentence, isToLearn, levelOfBase, levelOfTranslation, sessionsOfBase, sessionsOfTranslation, nextSessionOfBase, nextSessionOfTranslation
    }
    
    func encode(to encoder: any Encoder) throws {
        
    }
    
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: Vocabulary.self, contentType: .vocabulary)
    }
}

extension Vocabulary {
    static var new: Vocabulary {
        Vocabulary(baseWord: "", baseSentence: "", translationWord: "", translationSentence: "", isToLearn: false, levelOfBase: .lvl1, levelOfTranslation: .lvl1, sessionsOfBase: [], sessionsOfTranslation: [], nextSessionOfBase: Date.now, nextSessionOfTranslation: Date.now)
    }
}

extension Vocabulary: Learnable {
    var sessionsOfFront: Array<Date> {
        get {
            self.sessionsOfBase
        }
        set {
            self.sessionsOfBase = newValue
        }
    }
    
    var nextSessionOfFront: Date {
        get {
            self.nextSessionOfBase
        }
        set {
            self.nextSessionOfBase = newValue
        }
    }
    
    var nextSessionOfBack: Date {
        get {
            self.nextSessionOfTranslation
        }
        set {
            self.nextSessionOfTranslation = newValue
        }
    }
    
    var sessionsOfBack: Array<Date> {
        get {
            self.sessionsOfTranslation
        }
        set {
            self.sessionsOfTranslation = newValue
        }
    }
    
    var primaryContentOfFront: String {
        get {
            self.baseWord
        }
        set {
            self.baseWord = newValue
        }
    }
    
    var secondaryContentOfFront: String {
        get {
            self.baseSentence
        }
        set {
            self.baseSentence = newValue
        }
    }
    
    var primaryContentOfBack: String {
        get {
            self.translationWord
        }
        set {
            self.translationWord = newValue
        }
    }
    
    var secondaryContentOfBack: String {
        get {
            self.translationSentence
        }
        set {
            self.translationSentence = newValue
        }
    }
    
    var levelOfFront: LearningLevel {
        get {
            self.levelOfBase
        }
        set {
            self.levelOfBase = newValue
        }
    }
    
    var levelOfBack: LearningLevel {
        get {
            self.levelOfTranslation
        }
        set {
            self.levelOfTranslation = newValue
        }
    }
    
    func answerTrue(askingSide: IndexCard<Vocabulary>.Side) {
        switch askingSide {
        case .front:
            let currentDate = Date.now
            self.levelOfBase = self.levelOfBase.nextLevel() ?? .max
            self.sessionsOfBase.append(currentDate)
            self.nextSessionOfBase = self.levelOfBase.nextSession(latestSession: currentDate)
        case .back:
            let currentDate = Date.now
            self.levelOfTranslation = self.levelOfTranslation.nextLevel() ?? .max
            self.sessionsOfTranslation.append(currentDate)
            self.nextSessionOfTranslation = self.levelOfTranslation.nextSession(latestSession: currentDate)
        }
    }
    
    func answerWrong(askingSide: IndexCard<Vocabulary>.Side) {
        switch askingSide {
        case .front:
            let currentDate = Date.now
            self.levelOfBase = self.levelOfBase.previousLevel() ?? .min
            self.sessionsOfBase.append(currentDate)
            self.nextSessionOfBase = self.levelOfBase.nextSession(latestSession: currentDate)
        case .back:
            let currentDate = Date.now
            self.levelOfTranslation = self.levelOfTranslation.previousLevel() ?? .max
            self.sessionsOfTranslation.append(currentDate)
            self.nextSessionOfTranslation = self.levelOfTranslation.nextSession(latestSession: currentDate)
        }
    }
}


