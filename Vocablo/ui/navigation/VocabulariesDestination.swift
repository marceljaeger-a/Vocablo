//
//  DetailRootView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 20.03.24.
//

import Foundation
import SwiftUI

struct VocabulariesDestination: View {
    
    //MARK: - Dependencies
    
    @Binding var selectedDeckValue: DeckSelectingValue
    
    @State var selectedVocabularies: Set<Vocabulary> = []
    @Environment(PresentationModel.self) var presentationModel
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        DeckListView(selectedDeckValue: selectedDeckValue, selectedVocabularies: $selectedVocabularies)
            .onChange(of: selectedDeckValue) {
                selectedVocabularies = []
            }
            .contextMenu(forSelectionType: Vocabulary.self) { vocabularies in
                DeckListViewContextMenu(vocabulariesOfContextMenu: vocabularies, selectedDeckValue: selectedDeckValue, selectedVocabularies: $selectedVocabularies)
            } primaryAction: { vocabularies in
                if vocabularies.count == 1 {
                    presentationModel.showVocabularyDetailSheet(edit: vocabularies.first)
                }
            }
            .toolbar {
                DeckListViewToolbar(selectedDeckValue: selectedDeckValue)
            }
            .sheet(isPresented: presentationModel.bindable.isVocabularyDetailSheetShown) {
                EditVocabularyView(editingVocabulary: presentationModel.bindable.editingVocabulary, addNewVocabularyToDeck: { selectedDeckValue.deck?.vocabularies.append($0) })
                    .frame(minWidth: 250, maxWidth: 800, minHeight: 250, maxHeight: 800)
            }
            .focusedValue(\.selectedVocabularies, $selectedVocabularies)
    }
}
