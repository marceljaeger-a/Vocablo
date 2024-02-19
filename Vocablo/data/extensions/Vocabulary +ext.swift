//
//  Vocabulary +ext.swift
//  Vocablo
//
//  Created by Marcel Jäger on 19.02.24.
//

import Foundation
import SwiftData
extension Vocabulary {
    static var newVocabulary: Vocabulary {
        Vocabulary(baseWord: "", translationWord: "", wordGroup: .noun)
    }
}
