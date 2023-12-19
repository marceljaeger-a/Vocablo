//
//  VocabularyList.swift
//  Vocablo
//
//  Created by Marcel Jäger on 23.10.23.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

@Model
class VocabularyList {
    
    //MARK: - Nested Types
    enum VocabularySorting: String, Codable {
        case newest = "Newest", oldest = "Oldest", word = "Word", translatedWord = "Translated Word"
        
        ///Returns the KeyPathComparator by the current case.
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
        
        ///Returns a TupleView of Text views for a picker´s content.
        @ViewBuilder static var pickerContent: some View {
            Text("Oldest").tag(VocabularySorting.oldest)
            Text("Newest").tag(VocabularySorting.newest)
            Text("Word").tag(VocabularySorting.word)
            Text("Translated Word").tag(VocabularySorting.translatedWord)
        }
    }
    
    //MARK: - Instanz Properties

    var name: String
    var created: Date
    var sorting: VocabularySorting = VocabularySorting.newest
    
    @Relationship(deleteRule: .nullify, inverse: \Vocabulary.list) var vocabularies: Array<Vocabulary>
    
    ///Returns a sorted array with Vocabularyies by the sorting property.
    var sortedVocabularies: Array<Vocabulary> {
        vocabularies.sorted(using: sorting.sortComparator)
    }
    
    ///Returns a filtered array with Vocabularies, which toLearn property is true.
    var toLearnVocabularies: Array<Vocabulary> {
        vocabularies.filter{ $0.isToLearn }
    }
    
    @Transient let addVocabularyPublisher: PassthroughSubject<Vocabulary, Never> = PassthroughSubject()
    
    
    //MARK: - Initialiser
    
    init(_ name: String, vocabularies: Array<Vocabulary> = []) {
        self.name = name
        self.created = Date.now
        self.vocabularies = vocabularies
    }
    
    //MARK: - Instanz Methodes
    
    ///Add the Vocabulary to the list.
    ///Sends a publisher message with the new vocabulary instance to subscribers.
    func addVocabulary(_ vocabulary: Vocabulary) {
        self.vocabularies.append(vocabulary)
        addVocabularyPublisher.send(vocabulary)
    }
    
    ///Removes the Vocabulary from the list.
    func removeVocabulary(_ vocabulary: Vocabulary) {
        self.vocabularies.removeAll { element in
            element == vocabulary
        }
    }
    
    ///Returns true, when the list contains the Vocabulary.
    func containVocabulary(_ vocabulary: Vocabulary) -> Bool {
        self.vocabularies.contains { item in
            item == vocabulary
        }
    }
}



//MARK: - Instanz Methodes for View

extension VocabularyList {
    
    ///Add a new Vocabulary with empty strings and word group as noun.
    func addNewVocabulary() {
        let newVocabulary = Vocabulary(word: "", translatedWord: "", wordGroup: .noun)
        addVocabulary(newVocabulary)
    }
}



