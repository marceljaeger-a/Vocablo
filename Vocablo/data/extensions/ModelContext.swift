//
//  ModelContext.swift
//  Vocablo
//
//  Created by Marcel Jäger on 28.11.23.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

//MARK: - Methodes for fetching

extension ModelContext {
    
    ///Returns a Array of fetched models by the identifiers.
    func fetch<T: PersistentModel>(by identifiers: Set<PersistentIdentifier>) -> Array<T> {
        let descriptor = FetchDescriptor<T>(predicate: #Predicate { identifiers.contains($0.persistentModelID) })
        if let fetchedData = try? self.fetch<T>(descriptor) {
            return fetchedData
        }
        return []
    }
    
    ///Returns the count of fetched VocabularyList instances by the identifiers.
    func fetchListCound(by identifiers: Set<PersistentIdentifier>) -> Int {
        let descriptor = FetchDescriptor<VocabularyList>(predicate: #Predicate{ identifiers.contains($0.persistentModelID) })
        if let fetchedListCount = try? self.fetchCount(descriptor) {
            return fetchedListCount
        }
        return 0
    }
    
    ///Returns the count of fetched Vocabulary instances by the identifiers.
    func fetchVocabularyCount(by identifiers: Set<PersistentIdentifier>) -> Int {
        let descriptor = FetchDescriptor<Vocabulary>(predicate: #Predicate{ identifiers.contains($0.persistentModelID) })
        if let fetchedVocabularyCount = try? self.fetchCount(descriptor) {
            return fetchedVocabularyCount
        }
        return 0
    }
}



//MARK: - Methodes for adding

extension ModelContext {
    
    ///Inserts a new list with the given name into the model context.
    ///Sends a publisher message with the new list instance to subcribers.
    func addList(_ name: String) {
        let newList = VocabularyList(name)
        insert(newList)
        ModelContext.addListPublisher.send(newList)
    }
}



//MARK: - Methodes for deleting

extension ModelContext {
    
    ///Deletes vocabularies from the model context.
    func deleteVocabularies(_ deletingVocabularies: Array<Vocabulary>) {
        for deletingVocabulary in deletingVocabularies {
            if let list = deletingVocabulary.list {
                list.removeVocabulary(deletingVocabulary)
            }
            self.delete(deletingVocabulary)
        }
    }
    
    ///Deletes lists from the model context.
    func deleteLists(_ deletingVocabularyLists: Array<VocabularyList>) {
        for deletingVocabularyList in deletingVocabularyLists {
            deleteVocabularies(deletingVocabularyList.vocabularies)
            self.delete(deletingVocabularyList)
        }
    }
}



//MARK: - Methodes for learning functionality

extension ModelContext {
    
    ///Resets the learningState and translatedLearningState  of all list´s vocabularies.
    func resetLearningStates(of lists: Array<VocabularyList>) {
        for list in lists {
            for vocabulary in list.vocabularies {
                vocabulary.baseState.reset()
                vocabulary.translationState.reset()
            }
        }
    }
    
    ///Resets the learningState and translatedLearningState of all vocabularies.
    func resetLearningStates(of vocabularies: Array<Vocabulary>) {
        for vocabulary in vocabularies {
            vocabulary.baseState.reset()
            vocabulary.translationState.reset()
        }
    }
    
    ///Sets the toLearn property of all vocabularies to true.
    func checkToLearn(of vocabularies: Array<Vocabulary>) {
        for vocabulary in vocabularies {
            guard !vocabulary.isToLearn else { continue }
            vocabulary.checkToLearn()
        }
    }
    
    ///Sets the toLearn property of all vocabularies to false.
    func uncheckToLearn(of vocabularies: Array<Vocabulary>) {
        for vocabulary in vocabularies {
            guard vocabulary.isToLearn else { continue }
            vocabulary.uncheckToLearn()
        }
    }
}



//MARK: - Type Properties (Publisher)
extension ModelContext {
    static let addListPublisher: PassthroughSubject<VocabularyList, Never> = PassthroughSubject()
}

