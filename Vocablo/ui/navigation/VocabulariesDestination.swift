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
    @Environment(ModalPresentationModel.self) var presentationModel
    
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
            .modifier(VocabularyDetailSheetModifier(selectedDeckValue: selectedDeckValue))
            .focusedValue(\.selectedVocabularies, $selectedVocabularies)
    }
}
