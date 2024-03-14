//
//  VocabularyListViewContextMenu.swift
//  Vocablo
//
//  Created by Marcel Jäger on 06.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct VocabularyListViewContextMenu: View {
    let vocabulariesOfContextMenu: Set<Vocabulary>
    let selectedList: ListSelectingValue
    @Binding var selectedVocabularies: Set<Vocabulary>
    @Binding var editedVocabulary: Vocabulary?
    @Environment(\.isSearching) private var isSearching
    
    init(
        vocabulariesOfContextMenu: Set<Vocabulary>,
        selectedList: ListSelectingValue,
        selectedVocabularies: Binding<Set<Vocabulary>>,
        editedVocabulary: Binding<Vocabulary?>
    ) {
        self.vocabulariesOfContextMenu = vocabulariesOfContextMenu
        self.selectedList = selectedList
        self._selectedVocabularies = selectedVocabularies
        self._editedVocabulary = editedVocabulary
    }
    
    var body: some View {
        AddNewVocabularyButton(into: selectedList.list)
            .disabled(
                vocabulariesOfContextMenu.isEmpty == false &&
                isSearching == false
            )
        
        Divider()
        
        OpenEditVocabularyViewButton(sheetValue: $editedVocabulary, open: vocabulariesOfContextMenu.first)
            .disabled(vocabulariesOfContextMenu.count != 1)
        
        SetVocabulariesToLearnButton(vocabulariesOfContextMenu, to: true) {
            Text("Set to learn")
        }
        .disabled(vocabulariesOfContextMenu.isEmpty)
        
        SetVocabulariesToLearnButton(vocabulariesOfContextMenu, to: false) {
            Text("Set not to learn")
        }
        .disabled(vocabulariesOfContextMenu.isEmpty)
        
        Divider()
        
        ResetVocabulariesButton(vocabularies: vocabulariesOfContextMenu)
            .disabled(vocabulariesOfContextMenu.isEmpty)
        
        DeleteVocabulariesButton(vocabularies: vocabulariesOfContextMenu, selectedVocabularies: $selectedVocabularies)
            .disabled(vocabulariesOfContextMenu.isEmpty)
    }
}
