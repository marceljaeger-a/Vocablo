//
//  AllVocabularyListView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 06.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct AllVocabularyListView: View {
    
    //MARK: - Dependencies
    
    @Query var vocabularies: Array<Vocabulary>
    
    @State var selectedVocabularies: Set<Vocabulary> = []
    @State var editedVocabulary: Vocabulary?
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Initialiser
    
    init(vocabularySortingKey: VocabularySortingKey, vocabularySortingOrder: SortingOrder) {
        self._vocabularies = Query(sort: [SortDescriptor<Vocabulary>.vocabularySortDescriptor(by: vocabularySortingKey, order: vocabularySortingOrder)])
    }
    
    //MARK: - Methods
    
    private func onSumbmitAction() {
        let newVocabulary = Vocabulary.newVocabulary
        modelContext.insert(newVocabulary)
        try? modelContext.save()
    }
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        VocabularyListView(vocabularies: vocabularies, selectedVocabularies: $selectedVocabularies, onSubmitRow: onSumbmitAction)
            .contextMenu(forSelectionType: Vocabulary.self) { vocabularies in
                VocabularyListViewContextMenu(vocabulariesOfContextMenu: vocabularies, of: nil, selectedVocabularies: $selectedVocabularies, editedVocabulary: $editedVocabulary, isSearching: false)
            } primaryAction: { vocabularies in
                if vocabularies.count == 1 {
                    editedVocabulary = vocabularies.first
                }
            }
            .toolbar {
                VocabularyListViewToolbar(selectedList: nil)
            }
            .sheet(item: $editedVocabulary) { vocabulary in
                EditVocabularyView(vocabulary: vocabulary)
            }
            .focusedValue(\.selectedVocabularies, $selectedVocabularies)
    }
}
