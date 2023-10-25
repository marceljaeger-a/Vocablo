//
//  VocabularyList.swift
//  Vocablo
//
//  Created by Marcel Jäger on 23.10.23.
//

import Foundation
import SwiftData

@Model
class VocabularyList {
    var name: String
    var created: Date
    
    @Relationship(deleteRule: .nullify, inverse: \Vocabulary.list) var vocabularies: Array<Vocabulary>
    
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
}
