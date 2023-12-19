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
    
    
    //MARK: - Body
    
    var body: some View {
        List(vocabularies, id: \.id, selection: $selection){ vocabulary in
            VocabularyItem(vocabulary: vocabulary, textFieldFocus: $textFieldFocus)
                .onSubmit {
                    onSubmitAction()
                }
        }
    }
}


