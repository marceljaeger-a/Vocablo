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
    @Binding var editedVocabulary: Vocabulary?
    let selectedList: VocabularyList?
    
    @FocusState var focusedVocabularyTextField: FocusedVocabularyTextField?
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        List(selection: $selectedVocabularies) {
            ForEach(vocabularies, id: \.self) { vocabulary in
                VocabularyRow(vocabulary: vocabulary, focusedTextField: $focusedVocabularyTextField, list: selectedList)
            }
        }
        .listStyle(.inset)
        .focusedValue(\.selectedVocabularies, $selectedVocabularies)
    }
}



enum FocusedVocabularyTextField: Hashable {
    case baseWord(vocabularyIdentifier: PersistentIdentifier)
    case translationWord(vocabularyIdentifier: PersistentIdentifier)
    case baseSentence(vocabularyIdentifier: PersistentIdentifier)
    case translationSentence(vocabularyIdentifier: PersistentIdentifier)
}

