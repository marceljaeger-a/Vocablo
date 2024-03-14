//
//  Detail.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.02.24.
//

import Foundation
import SwiftUI
import SwiftData

struct Detail: View {
    
    //MARK: - Dependencies
    
    @Binding var selectedList: ListSelectingValue
    
    @State var selectedVocabularies: Set<Vocabulary> = []
    @State var editedVocabulary: Vocabulary?
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        VocabularyListView(selectedListValue: selectedList, selectedVocabularies: $selectedVocabularies)
            .onChange(of: selectedList) {
                selectedVocabularies = []
            }
            .contextMenu(forSelectionType: Vocabulary.self) { vocabularies in
                VocabularyListViewContextMenu(vocabulariesOfContextMenu: vocabularies, selectedList: selectedList, selectedVocabularies: $selectedVocabularies, editedVocabulary: $editedVocabulary)
            } primaryAction: { vocabularies in
                if vocabularies.count == 1 {
                    editedVocabulary = vocabularies.first
                }
            }
            .toolbar {
                VocabularyListViewToolbar(selectedList: selectedList)
            }
            .sheet(item: $editedVocabulary) { vocabulary in
                EditVocabularyView(vocabulary: vocabulary)
            }
            .focusedValue(\.selectedVocabularies, $selectedVocabularies)
    }
}





