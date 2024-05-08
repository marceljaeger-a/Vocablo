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

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            LearnVocabulariesButton(selectedDeckValue: selectedDeckValue)
                .disabled(isSearching)
        }
        
        ToolbarItem(placement: .primaryAction) {
            AddNewVocabularyButton(into: selectedDeckValue.deck)
                .disabled(isSearching)
        }
    }
}
