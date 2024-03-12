//
//  PasteVocabulariesModifier.swift
//  Vocablo
//
//  Created by Marcel Jäger on 11.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct PasteVocabulariesModifier: ViewModifier {
    
    @Environment(\.modelContext) var modelContext
    let selectedList: ListSelectingValue
    
    private func pasteVocabularies(values: Array<Vocabulary.VocabularyTransfer>) {
        switch selectedList {
        case .all:
            let vocabularies = values.map { Vocabulary(from: $0) }
            for vocabulary in vocabularies {
                modelContext.insert(vocabulary)
            }
        case .list(let list):
            let vocabularies = values.map { Vocabulary(from: $0) }
            for vocabulary in vocabularies {
                list.append(vocabulary: vocabulary)
            }
        }
    }
    
    func body(content: Content) -> some View {
        content.pasteDestination(for: Vocabulary.VocabularyTransfer.self) { values in
            pasteVocabularies(values: values)
        }
    }
}
