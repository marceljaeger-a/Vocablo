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

extension ModelContext {
    
    ///Returns the fetched VocabularyLists.
    ///- Returns: An emptry Array if the wrapped fetch method throws an error.
    func fetchLists(_ descriptor: FetchDescriptor<VocabularyList>) -> Array<VocabularyList> {
        ( try? self.fetch(descriptor) ) ?? []
    }
    
    ///Returns the fetched Vocabularies.
    ///- Returns: An emptry Array if the wrapped fetch method throws an error.
    func fetchVocabularies(_ descriptor: FetchDescriptor<Vocabulary>) -> Array<Vocabulary> {
        ( try? self.fetch(descriptor) ) ?? []
    }
    
    ///Deletes a array of model from the model context and saves.
    ///
    ///> If you delete vocabularies without this methode, the UndoManager will no be able to register the unrelating!
    ///
    ///> If you delete lists without this methode, the contained vocabularies will not be deleted and the UndoManager will not be able to register the unrelated so after undo the vocabularies will not be in the list!
    func delete(models: Array<any PersistentModel>) {
        if let deletingVocabularies = models as? Array<Vocabulary> {
            
            for deletingVocabulary in deletingVocabularies {
                if let list = deletingVocabulary.list {
                    list.remove(vocabulary: deletingVocabulary)
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



