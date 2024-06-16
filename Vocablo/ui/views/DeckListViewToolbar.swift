//
//  VocabularyListViewToolbar.swift
//  Vocablo
//
//  Created by Marcel Jäger on 06.03.24.
//

import Foundation
import SwiftData
import SwiftUI

struct DeckListViewToolbar: ToolbarContent {
    let selectedDeckValue: DeckSelectingValue
    @Environment(\.isSearching) private var isSearching
    @Environment(ModalPresentationModel.self) var presentationModel
    
    var isNewVocabularyButtonDisabled: Bool {
        if isSearching {
            return true
        }
        if selectedDeckValue == .all {
            return true
        }
        
        return false
    }

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            LearnVocabulariesButton(selectedDeckValue: selectedDeckValue)
                .disabled(isSearching)
        }
        
        ToolbarItem(placement: .primaryAction) {
            Button {
                presentationModel.showVocabularyDetailSheet(edit: nil)
            } label: {
                Label("New vocabulary", systemImage: "plus")
            }
            .disabled(isNewVocabularyButtonDisabled)
        }
    }
}
