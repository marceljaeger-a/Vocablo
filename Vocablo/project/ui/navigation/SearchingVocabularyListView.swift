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
    
    var searchingFilter: Optional<(Vocabulary, String) -> Bool> = nil
    var searchingText: Optional<String> = nil
    
    @Query private var vocabularies: Array<Vocabulary>
    private var filteredVocabularies: Array<Vocabulary> {
        if let searchingFilter, let searchingText{
            return vocabularies.filter {
                searchingFilter($0, searchingText)
            }
        }else {
            return vocabularies
        }
    }
    
    @State private var selectedVocabularies: Set<Vocabulary> = []
    @State private var editedVocabulary: Vocabulary? = nil
    
    init(
        query: Query<Vocabulary, Array<Vocabulary>> = .init(.vocabularies()),
        searchingText: String
    ) {
        self._vocabularies = query
        
        self.searchingText = searchingText
        self.searchingFilter = {
            vocabulary, searchingText in
                vocabulary.baseWord.caseInsensitiveContains(searchingText) ||
                vocabulary.translationWord.caseInsensitiveContains(searchingText) ||
                vocabulary.baseSentence.caseInsensitiveContains(searchingText) ||
                vocabulary.translationSentence.caseInsensitiveContains(searchingText)
        }
    }
    
    var body: some View {
        let _ = Self._printChanges()
        VocabularyListView(vocabularies: filteredVocabularies, selectedVocabularies: $selectedVocabularies, editedVocabulary: $editedVocabulary, selectedList: nil)
            .contextMenu(forSelectionType: Vocabulary.self) { vocabularies in
                VocabularyListViewContextMenu(vocabulariesOfContextMenu: vocabularies, of: nil, selectedVocabularies: $selectedVocabularies, editedVocabulary: $editedVocabulary, isSearching: true)
            } primaryAction: { vocabularies in
                if vocabularies.count == 1 {
                    editedVocabulary = vocabularies.first
                }
            }
            .toolbar {
                VocabularyListViewToolbar(selectedList: nil, isSearching: true)
            }
            .sheet(item: $editedVocabulary) { vocabulary in
                EditVocabularyView(vocabulary: vocabulary)
            }
    }
}
