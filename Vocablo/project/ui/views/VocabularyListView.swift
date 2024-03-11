//
//  VocabularyListView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.02.24.
//

import Foundation
import SwiftUI
import SwiftData

struct VocabularyListView: View {
    
    //MARK: - Dependencies
    
    let vocabularies: Array<Vocabulary>
    @Binding var selectedVocabularies: Set<Vocabulary>
    let onSubmitRow: () -> Void
    
    @FocusState var focusedVocabularyTextField: FocusedVocabularyTextField?
    
    //MARK: - Methods
    
    private func isSelected(_ vocabulary: Vocabulary) -> Bool {
        selectedVocabularies.contains(vocabulary)
    }
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        List(selection: $selectedVocabularies) {
            ForEach(vocabularies, id: \.self) { vocabulary in
                VocabularyRow(vocabulary: vocabulary, focusedTextField: $focusedVocabularyTextField,isSelected: isSelected(vocabulary))
                    .onSubmit(onSubmitRow)
            }
        }
        .listStyle(.inset)
    }
}



enum FocusedVocabularyTextField: Hashable {
    case baseWord(vocabularyIdentifier: PersistentIdentifier)
    case translationWord(vocabularyIdentifier: PersistentIdentifier)
    case baseSentence(vocabularyIdentifier: PersistentIdentifier)
    case translationSentence(vocabularyIdentifier: PersistentIdentifier)
}

