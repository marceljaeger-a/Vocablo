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

extension Vocabulary {
    func hasTag(_ tag: Tag) -> Bool {
        tags.contains { element in
            element == tag
        }
    }
    
    func tag(_ tag: Tag) {
        guard !hasTag(tag) else { return }
        tags.append(tag)
    }
    
    func untag(_ tag: Tag){
        guard hasTag(tag) else { return }
        tags.removeAll { element in
            element == tag
        }
    }
    
    func toggleTag(_ tag: Tag) {
        if hasTag(tag) {
            self.untag(tag)
        }else {
            self.tag(tag)
        }
    }
}
