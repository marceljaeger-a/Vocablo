//
//  Tag.swift
//  Vocablo
//
//  Created by Marcel Jäger on 24.10.23.
//

import Foundation
import SwiftData

@Model
class Tag {
    var name: String
    var created: Date
    
    @Relationship(deleteRule: .nullify, inverse: \Vocabulary.tags) var vocabularies: Array<Vocabulary>
    
    init(_ name: String, vocabularies: Array<Vocabulary> = []) {
        self.name = name
        self.created = Date.now
        self.vocabularies = vocabularies
    }
}
