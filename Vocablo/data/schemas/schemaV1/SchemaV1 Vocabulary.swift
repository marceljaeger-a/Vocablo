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
    class Vocabulary: Learnable, TransferConvertable {
        
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
        
        //MARK: - TransferConvertable implementation
        
        struct VocabularyTransfer: TransferType {
            //Learnable
            var isLearnable: Bool
            var baseState: LearningState
            var translationState: LearningState
            var baseWord: String
            var translationWord: String
            var baseSentence: String
            var translationSentence: String
            
            //Model
            var wordGroup: WordGroup
            var baseExplenation: String
            var translationExplenation: String
            
            static var transferRepresentation: some TransferRepresentation {
                CodableRepresentation(for: Self.self, contentType: .vocabulary)
            }
        }
        
        required convenience init(from value: VocabularyTransfer) {
            self.init(baseWord: value.baseWord, translationWord: value.translationWord, baseSentence: value.baseSentence, translationSentence: value.translationSentence, wordGroup: value.wordGroup, baseExplenation: value.baseExplenation, translationExplenation: value.translationExplenation, list: nil, tags: [])
            self.isToLearn = value.isLearnable
            self.baseState = value.baseState
            self.translationState = value.translationState
        }
        
        ///Returns a VocabularyTransfer instanz, which has the same properties as that Vocabulary instanz.
        func convert() -> VocabularyTransfer{
            VocabularyTransfer.init(isLearnable: isToLearn, baseState: baseState, translationState: translationState, baseWord: baseWord, translationWord: translationWord, baseSentence: baseSentence, translationSentence: translationSentence, wordGroup: wordGroup, baseExplenation: baseExplenation, translationExplenation: translationExplanation)
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

