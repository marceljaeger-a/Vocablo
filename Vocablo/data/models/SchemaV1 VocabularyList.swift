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

extension SchemaV1 {
    @Model
    class VocabularyList {

        //MARK: - Nested Types
        enum VocabularySorting: String, Codable {
            case newest = "Newest", oldest = "Oldest", word = "Word", translatedWord = "Translated Word"
            
            ///Returns a SortDescriptor created by the current case.
            ///For a FetchDescriptor as example.
            var sortDescriptor: SortDescriptor<Vocabulary> {
                switch self {
                case .newest:
                    SortDescriptor(\Vocabulary.created, order: .reverse)
                case .oldest:
                    SortDescriptor(\Vocabulary.created, order: .forward)
                case .word:
                    SortDescriptor(\Vocabulary.baseWord)
                case .translatedWord:
                    SortDescriptor(\Vocabulary.translationWord)
                }
            }
            
            ///Returns the KeyPathComparator by the current case.
            ///For a collection methode as example.
            var sortComparator: KeyPathComparator<Vocabulary> {
                switch self {
                case .newest:
                    KeyPathComparator(\Vocabulary.created, order: .reverse)
                case .oldest:
                    KeyPathComparator(\Vocabulary.created, order: .forward)
                case .word:
                    KeyPathComparator(\Vocabulary.baseWord)
                case .translatedWord:
                    KeyPathComparator(\Vocabulary.translationWord)
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
        
        @Relationship(deleteRule: .cascade, inverse: \Vocabulary.list) var vocabularies: Array<Vocabulary>
        
        ///Returns a sorted array with Vocabularyies by the sorting property.
        var sortedVocabularies: Array<Vocabulary> {
            vocabularies.sorted(using: sorting.sortComparator)
        }
        
        ///Returns a filtered array with Vocabularies, which toLearn property is true.
        var toLearnVocabularies: Array<Vocabulary> {
            vocabularies.filter{ $0.isToLearn }
        }
        
        //MARK: - Initialiser
        
        init(_ name: String, vocabularies: Array<Vocabulary> = []) {
            self.name = name
            self.created = Date.now
            self.vocabularies = vocabularies
        }
        
        //MARK: - Instanz Methodes
        
        ///Appends the vocabulary.
        func append(vocabulary: Vocabulary) {
            vocabularies.append(vocabulary)
        }
        
        ///Removes the Vocabulary from the list.
        ///
        ///> If you remove vocabularies without this methode, the UndoManager will not be able to register the unrelating!
        func remove(vocabulary: Vocabulary) {
            self.vocabularies.removeAll { element in
                element == vocabulary
            }
            
            if let undoManager = self.modelContext?.undoManager {
                undoManager.registerUndo(withTarget: self) { undoList in
                    let removedVocabulary = vocabulary
                    undoList.append(vocabulary: removedVocabulary)
                    undoManager.registerUndo(withTarget: undoList) { redoList in
                        let addedVocabulary = removedVocabulary
                        redoList.remove(vocabulary: addedVocabulary)
                    }
                }
            }
        }
        
        ///Resets both the baseState and translationState of related vocabularies.
        func resetLearningStates() {
            for vocabulary in vocabularies {
                vocabulary.baseState.reset()
                vocabulary.translationState.reset()
            }
        }
    }
}


