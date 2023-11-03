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

@Model
class Vocabulary: Learnable {
    //Learnable implementation
    var isLearnable: Bool = false
    var learningState: LearningState = LearningState.newly(.lvl1)
    var learningContext: (word: String, sentence: String, translatedWord: String, translatedSentence: String) {
        (self.word, self.sentence, self.translatedWord, self.translatedSentence)
    }
    
    var toLearnToday: Bool {
        guard isLearnable else { return false }
        
        let todayZeroDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: .now)
        let nextRepetititonZeroDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: learningState.nextRepetition)
        
        guard let todayZeroDate else { return false }
        guard let nextRepetititonZeroDate else { return false }
        
        if nextRepetititonZeroDate <= todayZeroDate {
            return true
        }
        return false
    }
    
    
    //Model implementation
    var word: String
    var translatedWord: String
    var sentence: String
    var translatedSentence: String
    var wordGroup: WordGroup
    var created: Date
    var explenation: String
    var translatedExplanation: String
    
    @Relationship(deleteRule: .nullify )var list: VocabularyList?
    @Relationship(deleteRule: .nullify) var tags: Array<Tag>
    
    init(word: String, translatedWord: String, sentence: String = "", translatedSentence: String = "", wordGroup: WordGroup, explenation: String = "", translatedExplenation: String = "", list: VocabularyList? = nil, tags: [Tag] = []) {
        self.word = word
        self.translatedWord = translatedWord
        self.sentence = sentence
        self.translatedSentence = translatedSentence
        self.wordGroup = wordGroup
        self.created = Date.now
        self.list = list
        self.tags = tags
        self.explenation = explenation
        self.translatedExplanation = translatedExplenation
    }
}

extension Vocabulary {
    func hasTag(_ tag: Tag) -> Bool {
        tags.contains { element in
            element == tag
        }
    }
    
    func safelyTag(_ tag: Tag) {
        guard !hasTag(tag) else { return }
        tags.append(tag)
    }
    
    func safelyUntag(_ tag: Tag){
        guard hasTag(tag) else { return }
        tags.removeAll { element in
            element == tag
        }
    }
    
    func toggleTag(_ tag: Tag) {
        if hasTag(tag) {
            self.safelyUntag(tag)
        }else {
            self.safelyTag(tag)
        }
    }
}

extension Vocabulary{
    struct TransferType: Codable, Transferable {
        var id: PersistentIdentifier
        
        func pickObject(fetched objects: Array<Vocabulary>) -> Vocabulary? {
            for object in objects {
                if object.id == self.id {
                    return object
                }
            }
            return nil
        }
        
        static var transferRepresentation: some TransferRepresentation {
            CodableRepresentation(for: TransferType.self, contentType: .vocabulary)
        }
    }
    
    var transferType: TransferType {
        TransferType(id: self.id)
    }
}

extension UTType {
    static var vocabulary: UTType {
        UTType(exportedAs: "com.marceljaeger.vocabulary")
    }
}
