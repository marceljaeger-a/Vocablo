//
//  VocabularyListView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 14.12.23.
//

import Foundation
import SwiftUI
import SwiftData

struct VocabulariesListView: View {
    
    //MARK: - Properties
    
    let vocabularies: Array<Vocabulary>
    @Binding var selection: Set<PersistentIdentifier>
    @FocusState.Binding var textFieldFocus: VocabularyTextFieldFocusState?
    let onSubmitAction: () -> Void
    
    @Environment(\.modelContext) var context: ModelContext
    
    //MARK: - Methodes
    
    private func delete(indexSet: IndexSet) {
        let deletingVocabularies = vocabularies[indexSet]
        
        for deletingVocabulary in deletingVocabularies {
            guard selection.contains(deletingVocabulary.id) else { break }
            selection.remove(deletingVocabulary.id)
        }

        context.deleteVocabularies(deletingVocabularies)
    }
    
    //MARK: - Body
    
    var body: some View {
        List(selection: $selection) {
            ForEach(vocabularies, id: \.id) { vocabulary in
                VocabularyItem(vocabulary: vocabulary, textFieldFocus: $textFieldFocus)
                    .onSubmit {
                        onSubmitAction()
                    }
            }
            .onDelete { indexSet in //Swipe & Delete menu command, when a vocabulary is slected.
                delete(indexSet: indexSet)
            }
        }
    }
}


