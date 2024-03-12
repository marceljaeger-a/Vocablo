//
//  Vocabulary.swift
//  Vocablo
//
//  Created by Marcel Jäger on 23.10.23.
//

import Foundation
import SwiftUI
import SwiftData
import UniformTypeIdentifiers

extension SchemaV1 {
    @Model
    class Vocabulary: Learnable, Hashable {
        
        //MARK: - Instanz Properties of Learnable
        
        var isToLearn: Bool = false
        var baseWord: String
        var translationWord: String
        var baseSentence: String
        var translationSentence: String
        var baseState: Vocablo.LearningState = Vocablo.LearningState()
        var translationState: Vocablo.LearningState = Vocablo.LearningState()
        
        //MARK: - Instanz Properties
        
        var wordGroup: WordGroup
        var created: Date
        var baseExplenation: String
        var translationExplanation: String
        
        @Relationship(deleteRule: .nullify) var list: VocabularyList?
        @Relationship(deleteRule: .nullify) var tags: Array<Tag>
        
        //MARK: - Initialiser
        
        init(baseWord: String, translationWord: String, baseSentence: String = "", translationSentence: String = "", wordGroup: WordGroup, baseExplenation: String = "", translationExplenation: String = "", list: VocabularyList? = nil, tags: [Tag] = []) {
            self.baseWord = baseWord
            self.translationWord = translationWord
            self.baseSentence = baseSentence
            self.translationSentence = translationSentence
            self.wordGroup = wordGroup
            self.created = Date.now
            self.list = list
            self.tags = tags
            self.baseExplenation = baseExplenation
            self.translationExplanation = translationExplenation
        }
        
        ///Removes that vocabulary from the list.
        ///
        ///> If you set the property to nil without this methode, the UndoManager will not be able to register the unrelating!
        func removeFromList() {
            if let list {
                list.remove(vocabulary: self)
            }
        }
        
        ///Resets both the baseState and the translationState.
        func resetLearningsStates() {
            baseState.reset()
            translationState.reset()
        }
        
        
        
        required init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.isToLearn = try container.decode(Bool.self, forKey: .isToLearn)
            self.baseWord = try container.decode(String.self, forKey: .baseWord)
            self.translationWord = try container.decode(String.self, forKey: .translationWord)
            self.baseSentence = try container.decode(String.self, forKey: .baseSentence)
            self.translationSentence = try container.decode(String.self, forKey: .translationSentence)
            self.baseState = try container.decode(LearningState.self, forKey: .baseState)
            self.translationState = try container.decode(LearningState.self, forKey: .translationState)
            self.wordGroup = try container.decode(WordGroup.self, forKey: .wordGroup)
            
            self.created = .now
            baseExplenation = ""
            translationExplanation = ""
            tags = []
        }
        
        
        required init(copyOf value: SchemaV1.Vocabulary) {
            self.isToLearn = value.isToLearn
            self.baseWord = value.baseWord
            self.translationWord = value.translationWord
            self.baseSentence = value.baseSentence
            self.translationSentence = value.translationSentence
            self.baseState = value.baseState
            self.translationState = value.translationState
            self.wordGroup = value.wordGroup
            
            self.created = .now
            self.baseExplenation = ""
            translationExplanation = ""
            tags = []
        }
    }
}



extension Vocabulary: Codable, Transferable, Copyable {
    enum CodingKeys: CodingKey {
        case isToLearn
        case baseWord, translationWord
        case baseSentence, translationSentence
        case baseState, translationState
        case wordGroup
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isToLearn, forKey: .isToLearn)
        try container.encode(baseWord, forKey: .baseWord)
        try container.encode(translationWord, forKey: .translationWord)
        try container.encode(baseSentence, forKey: .baseSentence)
        try container.encode(translationSentence, forKey: .translationSentence)
        try container.encode(baseState, forKey: .baseState)
        try container.encode(translationState, forKey: .translationState)
        try container.encode(wordGroup, forKey: .wordGroup)
    }
    
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: Vocabulary.self, contentType: .vocabulary)
    }
}


