//
//  SearchingVocabularyListView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 06.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct SearchingVocabularyListView: View {
    
    //MARK: - Dependencies
    
    @Query private var vocabularies: Array<Vocabulary>
    
    @State private var selectedVocabularies: Set<Vocabulary> = []
    @State private var editedVocabulary: Vocabulary? = nil
    
    //MARK: - Initialiser
    
    init(
        searchingText: String
    ) {
        let predicate: Predicate<Vocabulary> = #Predicate { vocabulary in
            vocabulary.baseWord.localizedStandardContains(searchingText) ||
            vocabulary.translationWord.localizedStandardContains(searchingText) ||
            vocabulary.baseSentence.localizedStandardContains(searchingText) ||
            vocabulary.translationSentence.localizedStandardContains(searchingText)
        }
        
        self._vocabularies = Query(filter: predicate)
    }
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        VocabularyListView(vocabularies: vocabularies, selectedVocabularies: $selectedVocabularies, onSubmitRow: {})
            .contextMenu(forSelectionType: Vocabulary.self) { vocabularies in
                VocabularyListViewContextMenu(vocabulariesOfContextMenu: vocabularies, of: nil, selectedVocabularies: $selectedVocabularies, editedVocabulary: $editedVocabulary, isSearching: true)
            } primaryAction: { vocabularies in
                if vocabularies.count == 1 {
                    editedVocabulary = vocabularies.first
                }
            }
            .sheet(item: $editedVocabulary) { vocabulary in
                EditVocabularyView(vocabulary: vocabulary)
            }
            .focusedValue(\.selectedVocabularies, $selectedVocabularies)
    }
}
