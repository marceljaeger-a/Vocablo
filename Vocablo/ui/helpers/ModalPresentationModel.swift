//
//  PresentationModel.swift
//  Vocablo
//
//  Created by Marcel Jäger on 14.05.24.
//

import Foundation
import SwiftUI

@Observable class ModalPresentationModel {
    
    var bindable: Bindable<ModalPresentationModel> {
        Bindable(self)
    }
    
    //MARK: - Vocabulary detail view
    
    var isVocabularyDetailSheetShown: Bool = false
    var editingVocabulary: Vocabulary? = nil
    
    func showVocabularyDetailSheet(edit vocabulary: Vocabulary?) {
        editingVocabulary = vocabulary
        isVocabularyDetailSheetShown = true
    }
    
    //MARK: - Deck detail view
    
    var isDeckDetailSheetShown: Bool = false
    var editingDeck: Deck? = nil
    
    func showDeckDetailSheet(edit deck: Deck?) {
        editingDeck = deck
        isDeckDetailSheetShown = true
    }
    
}
