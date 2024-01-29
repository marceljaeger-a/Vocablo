//
//  CutableVocabularies.swift
//  Vocablo
//
//  Created by Marcel Jäger on 07.12.23.
//

import Foundation
import SwiftUI
import SwiftData

extension View {
    func cuttableVocabularies(_ vocabularies: Array<Vocabulary>, context: ModelContext) -> some View {
        return self.cuttable(for: Vocabulary.VocabularyTransfer.self) {
            let cuttedVocabularies = vocabularies
            
            defer {
                for cuttedVocabulary in cuttedVocabularies {
                    if let list = cuttedVocabulary.list {
                        list.removeVocabulary(cuttedVocabulary)
                    }
                    
                    context.delete(cuttedVocabulary)
                }
            }

            return cuttedVocabularies.map{ $0.convert() }
        }
    }
}
