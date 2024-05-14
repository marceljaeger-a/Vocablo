//
//  PresentationModel.swift
//  Vocablo
//
//  Created by Marcel Jäger on 14.05.24.
//

import Foundation
import SwiftUI

@Observable class PresentationModel {
    
    var bindable: Bindable<PresentationModel> {
        Bindable(self)
    }
    
    var isVocabularyDetailSheetShown: Bool = false
    var editingVocabulary: Vocabulary? = nil
    
    func showVocabularyDetailSheet(edit vocabulary: Vocabulary?) {
        editingVocabulary = vocabulary
        isVocabularyDetailSheetShown = true
    }
    
}
