//
//  Vocabulary +extension.swift
//  Vocablo
//
//  Created by Marcel Jäger on 31.01.24.
//

import Foundation

extension Vocabulary: Duplicateable {
    static func isDuplicate(lhs: SchemaV1.Vocabulary, rhs: SchemaV1.Vocabulary) -> Bool {
        lhs.baseWord == rhs.baseWord && lhs.translationWord == rhs.translationWord && lhs.id != rhs.id
    }
}
