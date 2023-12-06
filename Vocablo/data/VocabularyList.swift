//
//  VocabularyList.swift
//  Vocablo
//
//  Created by Marcel Jäger on 23.10.23.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class VocabularyList {
    enum VocabularySorting: String, Codable {
        case newest = "Newest", oldest = "Oldest", word = "Word", translatedWord = "Translated Word"
        
        var sortComparator: KeyPathComparator<Vocabulary> {
            switch self {
            case .newest:
                KeyPathComparator(\Vocabulary.created, order: .reverse)
            case .oldest:
                KeyPathComparator(\Vocabulary.created, order: .forward)
            case .word:
                KeyPathComparator(\Vocabulary.word)
            case .translatedWord:
                KeyPathComparator(\Vocabulary.translatedWord)
            }
        }
        
        @ViewBuilder static var pickerContent: some View {
            Text("Oldest").tag(VocabularySorting.oldest)
            Text("Newest").tag(VocabularySorting.newest)
            Text("Word").tag(VocabularySorting.word)
            Text("Translated Word").tag(VocabularySorting.translatedWord)
        }
    }
    
    var name: String
    var created: Date
    var sorting: VocabularySorting = VocabularySorting.newest
    
    @Relationship(deleteRule: .nullify, inverse: \Vocabulary.list) var vocabularies: Array<Vocabulary>
    
    var sortedVocabularies: Array<Vocabulary> {
        vocabularies.sorted(using: sorting.sortComparator)
    }
    
    var learnableVocabularies: Array<Vocabulary> {
        vocabularies.filter{ $0.isLearnable }
    }
    
    init(_ name: String, vocabularies: Array<Vocabulary> = []) {
        self.name = name
        self.created = Date.now
        self.vocabularies = vocabularies
    }
}

extension VocabularyList {
    func addVocabulary(_ vocabulary: Vocabulary) {
        self.vocabularies.append(vocabulary)
    }
    
    func containVocabulary(_ vocabulary: Vocabulary) -> Bool {
        self.vocabularies.contains { item in
            item == vocabulary
        }
    }
    
    func removeVocabulary(_ vocabulary: Vocabulary) {
        self.vocabularies.removeAll { element in
            element == vocabulary
        }
    }
}



