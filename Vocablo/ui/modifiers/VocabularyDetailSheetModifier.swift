//
//  VocabularyDetailSheetModifier.swift
//  Vocablo
//
//  Created by Marcel Jäger on 14.05.24.
//

import Foundation
import SwiftUI

struct VocabularyDetailSheetModifier: ViewModifier {
    @Environment(ModalPresentationModel.self) var modalPresentationModel
    let selectedDeckValue: DeckSelectingValue
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: modalPresentationModel.bindable.isVocabularyDetailSheetShown) {  
                VocabularyDetailForm(
                    editingVocabulary: modalPresentationModel.bindable.editingVocabulary,
                    currentDeck: selectedDeckValue.deck
                )
            }
    }
}

