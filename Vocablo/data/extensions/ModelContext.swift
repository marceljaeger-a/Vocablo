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
    
    ///Returns the count of fetched models by the identifiers.
    func fetchCount<T: PersistentModel>(for : T.Type, by identifiers: Set<PersistentIdentifier>) -> Int {
        let predicate: Predicate<T> = #Predicate { element in
            identifiers.contains(element.persistentModelID)
        }
        let descriptor: FetchDescriptor<T> = FetchDescriptor(predicate: predicate)
        
        if let fetchedCount = try? self.fetchCount(descriptor) {
            return fetchedCount
        }
        return 0
    }
    
    ///Returns the count of fetched VocabularyList instances by the identifiers.
    func fetchListCound(by identifiers: Set<PersistentIdentifier>) -> Int {
        return fetchCount(for: VocabularyList.self, by: identifiers)
    }
    
    ///Returns the count of fetched Vocabulary instances by the identifiers.
    func fetchVocabularyCount(by identifiers: Set<PersistentIdentifier>) -> Int {
        return fetchCount(for: Vocabulary.self, by: identifiers)
    }
}



//MARK: - Methodes for adding

extension ModelContext {
    
    ///Inserts a new list with the given name into the model context.
    ///Sends a publisher message with the new list instance to subcribers.
    func addList(_ name: String) -> VocabularyList {
        let newList = VocabularyList(name)
        insert(newList)
        try? save() //Because the persistend identifier has a other value after saving.
        return newList
    }
}



//MARK: - Methodes for deleting

extension ModelContext {
    
    ///Deletes vocabularies from the model context.
    func deleteVocabularies(_ deletingVocabularies: Array<Vocabulary>) {
        //let fetchDescriptor = FetchDescriptor<Vocabulary>()
        //print(try? fetchCount(fetchDescriptor))
        
        for deletingVocabulary in deletingVocabularies {
            if let list = deletingVocabulary.list {
                list.removeVocabulary(deletingVocabulary)
            }
            self.delete(deletingVocabulary)
        }
        //print(try? fetchCount(fetchDescriptor))
        //try? save()
    }
    
    ///Deletes lists from the model context.
    func deleteLists(_ deletingVocabularyLists: Array<VocabularyList>) {
        for deletingVocabularyList in deletingVocabularyLists {
            self.delete(deletingVocabularyList)
        }
    }
    
    ///Delete a array of model from the model context.
    ///
    ///> If you delete vocabularies without this methode, the UndoManager will no be able to register the unrelating!
    ///
    ///> If you delete lists without this methode, the contained vocabularies will not be deleted and the UndoManager will not be able to register the unrelated so after undo the vocabularies will not be in the list!
    func delete(models: Array<any PersistentModel>) {
        if let deletingVocabularies = models as? Array<Vocabulary> {
            
            for deletingVocabulary in deletingVocabularies {
                if let list = deletingVocabulary.list {
                    list.removeVocabulary(deletingVocabulary)
                }
                self.delete(deletingVocabulary)
            }
            
        }else if let deletingLists = models as? Array<VocabularyList> {
            
            for deletingList in deletingLists {
                delete(models: deletingList.vocabularies)
                self.delete(deletingList)
            }
            
        }
        else {
            
            for model in models {
                self.delete(model)
            }
            
        }
        
        try? self.save()
    }
}



//MARK: - Methodes for learning functionality

extension ModelContext {
    
    ///Resets the learningState and translatedLearningState  of all list´s vocabularies.
    func resetLearningStates(vocabulariesOf lists: Array<VocabularyList>) {
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
    //static let addListPublisher: PassthroughSubject<VocabularyList, Never> = PassthroughSubject()
}

