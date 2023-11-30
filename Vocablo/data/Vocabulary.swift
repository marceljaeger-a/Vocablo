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
class Vocabulary: Learnable, TransferConvertable {
    
    //Learnable implementation
    var isLearnable: Bool = false
    var learningState: LearningState = LearningState.newly(.lvl1)
    var translatedLearningState: LearningState = LearningState.newly(.lvl1)
    var word: String
    var translatedWord: String
    var sentence: String
    var translatedSentence: String
    
    //Model implementation
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
    
    
    //TransferConvertable implementation
    required convenience init(from value: VocabularyTransfer) {
        self.init(word: value.word, translatedWord: value.translatedWord, sentence: value.sentence, translatedSentence: value.translatedSentence, wordGroup: value.wordGroup, explenation: value.explenation, translatedExplenation: value.translatedExplenation, list: nil, tags: [])
        self.isLearnable = value.isLearnable
        self.learningState = value.learningState
        self.translatedLearningState = value.translatedLearningState
    }
    
    func convert() -> VocabularyTransfer{
        VocabularyTransfer.init(isLearnable: isLearnable, learningState: learningState, translatedLearningState: translatedLearningState, word: word, translatedWord: translatedWord, sentence: sentence, translatedSentence: translatedSentence, wordGroup: wordGroup, explenation: explenation, translatedExplenation: translatedExplanation)
    }
    
    struct VocabularyTransfer: TransferType {
        //Learnable
        var isLearnable: Bool
        var learningState: LearningState
        var translatedLearningState: LearningState
        var word: String
        var translatedWord: String
        var sentence: String
        var translatedSentence: String

        //Model
        var wordGroup: WordGroup
        var explenation: String
        var translatedExplenation: String
        
        static var transferRepresentation: some TransferRepresentation {
            CodableRepresentation(for: Self.self, contentType: .vocabulary)
        }
    }
}

//extension Vocabulary {
//    func hasTag(_ tag: Tag) -> Bool {
//        tags.contains { element in
//            element == tag
//        }
//    }
//    
//    func safelyTag(_ tag: Tag) {
//        guard !hasTag(tag) else { return }
//        tags.append(tag)
//    }
//    
//    func safelyUntag(_ tag: Tag){
//        guard hasTag(tag) else { return }
//        tags.removeAll { element in
//            element == tag
//        }
//    }
//    
//    func toggleTag(_ tag: Tag) {
//        if hasTag(tag) {
//            self.safelyUntag(tag)
//        }else {
//            self.safelyTag(tag)
//        }
//    }
//}

