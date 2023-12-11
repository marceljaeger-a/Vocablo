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

//Fetching
extension ModelContext {
    func fetch<T: PersistentModel>(ids: Set<PersistentIdentifier>) -> Array<T> {
        let descriptor = FetchDescriptor<T>(predicate: #Predicate { ids.contains($0.persistentModelID) })
        if let fetchedData = try? self.fetch<T>(descriptor) {
            return fetchedData
        }
        return []
    }
    
    func fetchListCound(ids: Set<PersistentIdentifier>) -> Int {
        let descriptor = FetchDescriptor<VocabularyList>(predicate: #Predicate{ ids.contains($0.persistentModelID) })
        if let fetchedListCount = try? self.fetchCount(descriptor) {
            return fetchedListCount
        }
        return 0
    }
    
    func fetchVocabularyCount(ids: Set<PersistentIdentifier>) -> Int {
        let descriptor = FetchDescriptor<Vocabulary>(predicate: #Predicate{ ids.contains($0.persistentModelID) })
        if let fetchedVocabularyCount = try? self.fetchCount(descriptor) {
            return fetchedVocabularyCount
        }
        return 0
    }
}

//Adding
extension ModelContext {
    func addList(_ name: String) {
        let newList = VocabularyList(name)
        insert(newList)
        ModelContext.addListPublisher.send(newList)
    }
}

//Deleting
extension ModelContext {
    func deleteVocabularies(_ deletingVocabularies: Array<Vocabulary>) {
        for deletingVocabulary in deletingVocabularies {
            if let list = deletingVocabulary.list {
                list.removeVocabulary(deletingVocabulary)
            }
            self.delete(deletingVocabulary)
        }
    }
    
    func deleteLists(_ deletingVocabularyLists: Array<VocabularyList>) {
        for deletingVocabularyList in deletingVocabularyLists {
            self.delete(deletingVocabularyList)
        }
    }
}

//Learnable functionality
extension ModelContext {
    func resetList(_ lists: Array<VocabularyList>) {
        for list in lists {
            for vocabulary in list.vocabularies {
                vocabulary.learningState.reset()
                vocabulary.translatedLearningState.reset()
            }
        }
    }
    
    func resetVocabularies(_ vocabularies: Array<Vocabulary>) {
        for vocabulary in vocabularies {
            vocabulary.learningState.reset()
            vocabulary.translatedLearningState.reset()
        }
    }
    
    func toLearn(for vocabularies: Array<Vocabulary>) {
        for vocabulary in vocabularies {
            guard !vocabulary.isLearnable else { continue }
            vocabulary.checkLearnable()
        }
    }
    
    func notToLearn(for vocabularies: Array<Vocabulary>) {
        for vocabulary in vocabularies {
            guard vocabulary.isLearnable else { continue }
            vocabulary.uncheckLearnable()
        }
    }
}

extension ModelContext {
    static let addListPublisher: PassthroughSubject<VocabularyList, Never> = PassthroughSubject()
}

