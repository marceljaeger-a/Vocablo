//
//  ModelContext.swift
//  Vocablo
//
//  Created by Marcel Jäger on 28.11.23.
//

import Foundation
import SwiftData

extension ModelContext {
    func deleteVocabularies(_ deletingVocabularies: Array<Vocabulary>) {
        for deletingVocabulary in deletingVocabularies {
            deletingVocabulary.list = nil
            self.delete(deletingVocabulary)
        }
    }
    
    func deleteVocabularyLists(_ deletingVocabularyLists: Array<VocabularyList>) {
        for deletingVocabularyList in deletingVocabularyLists {
            self.delete(deletingVocabularyList)
        }
    }
}
