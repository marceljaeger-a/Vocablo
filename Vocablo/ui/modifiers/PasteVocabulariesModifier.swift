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
    
    private func pasteVocabularies(vocabularies: Array<Vocabulary>) {
        switch selectedList {
        case .all:
            for vocabulary in vocabularies {
                modelContext.insert(vocabulary)
            }
        case .list(let list):
            for vocabulary in vocabularies {
                list.append(vocabulary: vocabulary)
            }
        }
    }
    
    func body(content: Content) -> some View {
        content.pasteDestination(for: Vocabulary.self) { values in
            pasteVocabularies(vocabularies: values)
        }
    }
}
