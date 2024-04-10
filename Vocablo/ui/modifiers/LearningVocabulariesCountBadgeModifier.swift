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

    init(listValue: ListSelectingValue) {
        self._learningVocabularies = Query(.learningVocabularies(of: listValue))
    }
    
    var currentLearningValueCount: Int {
        LearningService.getLearnignValues(of: learningVocabularies).count
    }
    
    func body(content: Content) -> some View {
        let _ = Self._printChanges()
        content.badge(currentLearningValueCount).badgeProminence(.increased)
    }
}
