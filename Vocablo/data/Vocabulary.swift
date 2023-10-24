//
//  Vocabulary.swift
//  Vocablo
//
//  Created by Marcel Jäger on 23.10.23.
//

import Foundation
import SwiftData

@Model
class Vocabulary {
    var word: String
    var translatedWord: String
    var sentence: String
    var translatedSentence: String
    var wordGroup: WordGroup
    var created: Date
    var explenation: String
    var translatedExplanation: String
    
    var list: VocabularyList?
    var tags: Array<Tag>
    
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
