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
    let selectedDeckValue: DeckSelectingValue
    
    private func pasteVocabularies(vocabularies: Array<Vocabulary>) {
        switch selectedDeckValue {
        case .all:
            for vocabulary in vocabularies {
                modelContext.insert(vocabulary)
            }
        case .deck(let deck):
            for vocabulary in vocabularies {
                deck.vocabularies.append(vocabulary)
            }
        }
    }
    
    func body(content: Content) -> some View {
        content.pasteDestination(for: Vocabulary.self) { values in
            pasteVocabularies(vocabularies: values)
        }
    }
}
