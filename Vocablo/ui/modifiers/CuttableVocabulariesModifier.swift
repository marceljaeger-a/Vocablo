//
//  CutableVocabulariesModifier.swift
//  Vocablo
//
//  Created by Marcel Jäger on 11.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct CuttableVocabulariesModifier: ViewModifier {
    @FocusedBinding(\.selectedVocabularies) var selectedVocabularies: Set<Vocabulary>?
    @Environment(\.modelContext) var modelContext
    
    private func cutVocabularies() -> Array<Vocabulary> {
        if let selectedVocabularies {
            let convertedValues = selectedVocabularies.map{ $0.copy() }
            modelContext.delete(models: Array(selectedVocabularies))
            
            return convertedValues
        }
        return []
    }
    
    func body(content: Content) -> some View {
        content.cuttable(for: Vocabulary.self) {
            cutVocabularies()
        }
    }
}
