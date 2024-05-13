//
//  LearningVocabulariesCountBadgeModifier.swift
//  Vocablo
//
//  Created by Marcel Jäger on 10.04.24.
//

import Foundation
import SwiftUI
import SwiftData

struct LearningVocabulariesCountBadgeModifier: ViewModifier {
    
    @Query var learningVocabularies: Array<Vocabulary>

    init(deckValue: DeckSelectingValue) {
        self._learningVocabularies = Query(.learningVocabularies(of: deckValue))
    }
    
    var currentLearningValueCount: Int {
        let service = LearningService()
        return service.getFilteredSortedIndexCards(of: learningVocabularies).count
    }
    
    func body(content: Content) -> some View {
        let _ = Self._printChanges()
        content.badge(currentLearningValueCount).badgeProminence(.increased)
    }
}
