//
//  LearningService.swift
//  Vocablo
//
//  Created by Marcel Jäger on 20.03.24.
//
import Foundation
import SwiftData
import SwiftUI

struct LearningService {
    
    ///Returns an array of of IndexCards
    ///
    ///It creates for both sides a IndexCard and sort $ filter the values.
    ///
    /// - Parameters:
    ///     - vocabularies: The vocabularies you will create LearningValues with those.
    ///
    /// - Returns: The sorted IndexCards.
    func getFilteredSortedIndexCards<L: Learnable>(of values: Array<L>, currentSession: Date = Date.now) -> Array<IndexCard<L>> {
        
        let baseAskingLearningValues = values.map { IndexCard(value: $0, askingSide: .front) }.filter { $0.nextSession < currentSession }
        let translationAskingLearningValues = values.map { IndexCard(value: $0, askingSide: .back) }.filter { $0.nextSession < currentSession }
        
        let newBaseAskingLearningValues = baseAskingLearningValues
            .filter{ $0.isNew == true }
            .sorted(using: [KeyPathComparator(\.nextSession, order: .forward)])
        let notNewBaseAskingLearningValues = baseAskingLearningValues
            .filter{ $0.isNew == false }
        
        let newTranslationAskingLearningValues = translationAskingLearningValues
            .filter{ $0.isNew }
            .sorted(using: [KeyPathComparator(\.nextSession, order: .forward)])
        let notNewTranslationAskingLearningValues = translationAskingLearningValues
            .filter{ $0.isNew == false }
        
        let notNewLearningValues = (notNewBaseAskingLearningValues + notNewTranslationAskingLearningValues ).sorted(using: KeyPathComparator(\.nextSession, order: .forward))
        
        return newBaseAskingLearningValues + newTranslationAskingLearningValues + notNewLearningValues
    }
}
