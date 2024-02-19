//
//  FetchDescriptor +ext.swift
//  Vocablo
//
//  Created by Marcel Jäger on 19.02.24.
//

import Foundation
import SwiftData

extension FetchDescriptor {
    static func byIdentifiers(_ identifiers: Set<PersistentIdentifier>, sortBy sortDescriptors: [SortDescriptor<T>] = []) -> FetchDescriptor<T> {
        FetchDescriptor(predicate: #Predicate { identifiers.contains($0.persistentModelID) }, sortBy: sortDescriptors)
    }
    
    static func vocabularies(_ predicate: Predicate<Vocabulary>? = nil, sortBy sortDescriptors: [SortDescriptor<Vocabulary>] = []) -> FetchDescriptor<Vocabulary> {
        FetchDescriptor<Vocabulary>(predicate: predicate, sortBy: sortDescriptors)
    }
    
    static func lists(_ predicate: Predicate<VocabularyList>? = nil, sortBy sortDescriptors: [SortDescriptor<VocabularyList>] = []) -> FetchDescriptor<VocabularyList> {
        FetchDescriptor<VocabularyList>(predicate: predicate, sortBy: sortDescriptors)
    }
}
