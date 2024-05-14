//
//  VocabularyListViewContextMenu.swift
//  Vocablo
//
//  Created by Marcel Jäger on 06.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct DeckListViewContextMenu: View {
    let vocabulariesOfContextMenu: Set<Vocabulary>
    let selectedDeckValue: DeckSelectingValue
    @Binding var selectedVocabularies: Set<Vocabulary>
    @Environment(\.isSearching) private var isSearching
    @Environment(PresentationModel.self) var presentationModel
    
    init(
        vocabulariesOfContextMenu: Set<Vocabulary>,
        selectedDeckValue: DeckSelectingValue,
        selectedVocabularies: Binding<Set<Vocabulary>>
    ) {
        self.vocabulariesOfContextMenu = vocabulariesOfContextMenu
        self.selectedDeckValue = selectedDeckValue
        self._selectedVocabularies = selectedVocabularies
    }
    
    var body: some View {
        Button {
            presentationModel.showVocabularyDetailSheet(edit: nil)
        } label: {
            Label("New vocabulary", systemImage: "plus")
        }
        .disabled(
            vocabulariesOfContextMenu.isEmpty == false &&
            isSearching == false
        )
        
        Divider()
        
        OpenEditVocabularyViewButton(open: vocabulariesOfContextMenu.first)
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
