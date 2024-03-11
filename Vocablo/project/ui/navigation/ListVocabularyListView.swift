//
//  ListVocabularyListView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 06.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct ListVocabularyListView: View {
    
    //MARK: - Dependencies
    
    @Query private var vocabularies: Array<Vocabulary>
    let list: VocabularyList
    
    @State private var selectedVocabularies: Set<Vocabulary> = []
    @State private var editedVocabulary: Vocabulary? = nil
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Initialiser
    
    init(
        list: VocabularyList,
        sortVocabulariesBy sortDescriptor: Array<SortDescriptor<Vocabulary>> = []
    ) {
        self._vocabularies = Query(.vocabularies(of: list, sortBy: sortDescriptor))
        self.list = list
    }
    
    //MARK: - Initialiser
    
    private func onSumbmitAction() {
        let newVocabulary = Vocabulary.newVocabulary
        list.append(vocabulary: newVocabulary)
        try? modelContext.save()
    }

    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        VocabularyListView(vocabularies: vocabularies, selectedVocabularies: $selectedVocabularies, onSubmitRow: onSumbmitAction)
            .contextMenu(forSelectionType: Vocabulary.self) { vocabularies in
                VocabularyListViewContextMenu(vocabulariesOfContextMenu: vocabularies, of: list, selectedVocabularies: $selectedVocabularies, editedVocabulary: $editedVocabulary, isSearching: false)
            } primaryAction: { vocabularies in
                if vocabularies.count == 1 {
                    editedVocabulary = vocabularies.first
                }
            }
            .toolbar {
                VocabularyListViewToolbar(selectedList: list, isSearching: false)
            }
            .sheet(item: $editedVocabulary) { vocabulary in
                EditVocabularyView(vocabulary: vocabulary)
            }
            .focusedValue(\.selectedVocabularies, $selectedVocabularies)
    }
}
