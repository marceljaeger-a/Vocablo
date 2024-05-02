//
//  LearningDestination.swift
//  Vocablo
//
//  Created by Marcel Jäger on 21.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct LearningDestination: View {
    
    //MARK: - Dependencies
    
    @Query var vocabularies: Array<Vocabulary>
    
    //MARK: - Initialiser
    
    init(learningListValue: ListSelectingValue) {
        let query = Query(.learningVocabularies(of: learningListValue))
        self._vocabularies = query
    }
    
    //MARK: - Methods
    
    private func getLearnignValues() -> Array<LearningValue<Vocabulary>> {
        LearningService.getLearnignValues(of: vocabularies)
    }
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        let learningValues = getLearnignValues()
        
        if let firstLearningValue = learningValues.first {
            LearningValueView(of: firstLearningValue, learningValuesCount: learningValues.count)
                .background(.background)
        }else {
            ContentUnavailableView("No vocabulary to learn today!", systemImage: "calendar.badge.checkmark")
        }
    }
}
