//
//  VocabularyListView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 14.12.23.
//

import Foundation
import SwiftUI
import SwiftData

#warning("This view is not used!")
struct VocabulariesListView: View {
    
    //MARK: - Properties
    
    let vocabularies: Array<Vocabulary>
    @FocusState.Binding var textFieldFocus: VocabularyTextFieldFocusState?
    let onSubmitAction: () -> Void
    
    @Environment(\.modelContext) var context: ModelContext
    @Environment(\.selectionContext) var selections: SelectionContext
    
    //MARK: - Methodes
    
    private func delete(indexSet: IndexSet) {
        let deletingVocabularies = vocabularies[indexSet]
        _ = selections.unselectVocabularies(deletingVocabularies.identifiers)
        context.deleteVocabularies(deletingVocabularies)
    }
    
    //MARK: - Body
    
    var body: some View {
        List(selection: selections.bindable.selectedVocabularyIdentifiers) {
            ForEach(vocabularies, id: \.id) { vocabulary in
                VocabularyItem(vocabulary: vocabulary, textFieldFocus: $textFieldFocus, isDuplicateRecognitionLabelAvailable: true, isListLabelAvailable: false)
                    .onSubmit {
                        onSubmitAction()
                    }
            }
            .onDelete { indexSet in //Swipe & Delete menu command(not the keypress), when a vocabulary is slected.
                delete(indexSet: indexSet)
            }
        }
    }
}


