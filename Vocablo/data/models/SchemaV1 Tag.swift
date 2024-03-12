//
//  Tag.swift
//  Vocablo
//
//  Created by Marcel Jäger on 24.10.23.
//

import Foundation
import SwiftData

extension SchemaV1 {
    @Model
    class Tag {
        
        //MARK: - Instanz Properties
        
        var name: String
        var created: Date
        
        @Relationship(deleteRule: .nullify, inverse: \Vocabulary.tags) var vocabularies: Array<Vocabulary>
        
        //MARK: - Initialiser
        
        init(_ name: String, vocabularies: Array<Vocabulary> = []) {
            self.name = name
            self.created = Date.now
            self.vocabularies = vocabularies
        }
    }
}
