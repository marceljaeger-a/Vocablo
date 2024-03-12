//
//  FetchDescriptor +ext.swift
//  Vocablo
//
//  Created by Marcel Jäger on 19.02.24.
//

import Foundation
import SwiftData

extension FetchDescriptor {
    
    static func duplicatesOf(_ vocabulary: Vocabulary, withIn list: VocabularyList? = nil, sortBy sortDescriptors: [SortDescriptor<Vocabulary>] = []) -> FetchDescriptor<Vocabulary> {
        let listId = list?.persistentModelID
        let baseWord = vocabulary.baseWord
        let translationWord = vocabulary.translationWord
        let vocabularyId = vocabulary.persistentModelID
        let predicate: Predicate<Vocabulary>
        if let listId {
            predicate = #Predicate { otherVocabulary in
                baseWord == otherVocabulary.baseWord && translationWord == otherVocabulary.translationWord && vocabularyId != otherVocabulary.persistentModelID && listId == otherVocabulary.list?.persistentModelID
            }
           
        }else {
            predicate = #Predicate { otherVocabulary in
                baseWord == otherVocabulary.baseWord && translationWord == otherVocabulary.translationWord && vocabularyId != otherVocabulary.persistentModelID
            }
        }
        
        return FetchDescriptor<Vocabulary>(predicate: predicate, sortBy: sortDescriptors)
    }
    
//    static func modelsWithDuplicates() -> FetchDescriptor<Vocabulary> {
//        
//    }
}
