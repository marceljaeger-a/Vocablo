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
    static var shared = Self.init()
    
    ///Returns an array of LearningValues of the passed vocabularies.
    ///
    ///It creates for both learning states LearningValues and sort that Array by the alogrithm.
    ///
    /// - Parameters:
    ///     - vocabularies: The vocabularies you will create LearningValues with those.
    ///
    /// - Returns: The sorted LearningValues.
    func getLearnignValues(of vocabularies: Array<Vocabulary>) -> Array<LearningValue<Vocabulary>> {
        let baseAskingLearningValues = vocabularies.map { LearningValue(value: $0, askingContent: .base) }.filter { $0.askingState.isNextRepetitionExpired == true }
        let translationAskingLearningValues = vocabularies.map { LearningValue(value: $0, askingContent: .translation) }.filter { $0.askingState.isNextRepetitionExpired == true }
        
        let newBaseAskingLearningValues = baseAskingLearningValues
            .filter{ $0.askingState.isNewly }
            .sorted(using: [KeyPathComparator(\.askingState.nextRepetition, order: .forward)])
        let notNewBaseAskingLearningValues = baseAskingLearningValues
            .filter{ $0.askingState.isNewly == false }
        
        let newTranslationAskingLearningValues = translationAskingLearningValues
            .filter{ $0.askingState.isNewly }
            .sorted(using: [KeyPathComparator(\.askingState.nextRepetition, order: .forward)])
        let notNewTranslationAskingLearningValues = translationAskingLearningValues
            .filter{ $0.askingState.isNewly == false }
        
        let notNewLearningValues = (notNewBaseAskingLearningValues + notNewTranslationAskingLearningValues ).sorted(using: KeyPathComparator(\.askingState.nextRepetition, order: .forward))
        
        return newBaseAskingLearningValues + newTranslationAskingLearningValues + notNewLearningValues
    }
    
    ///Returns an array of LearningValues of the passed vocabularies.
    ///
    ///It creates for both learning states LearningValues and sort that Array by the alogrithm.
    ///
    ///This is a asyncronous variant of ``getLearnignValues(of:)-9l21d``.
    ///
    /// - Parameters:
    ///     - vocabularies: The vocabularies you will create LearningValues with those.
    ///
    /// - Returns: The sorted LearningValues.
    func getLearnignValues(of vocabularies: Array<Vocabulary>) async -> Array<LearningValue<Vocabulary>> {
        let baseAskingLearningValues = vocabularies.map { LearningValue(value: $0, askingContent: .base) }.filter { $0.askingState.isNextRepetitionExpired == true }
        let translationAskingLearningValues = vocabularies.map { LearningValue(value: $0, askingContent: .translation) }.filter { $0.askingState.isNextRepetitionExpired == true }
        
        async let newBaseAskingLearningValues = baseAskingLearningValues
            .filter{ $0.askingState.isNewly }
            .sorted(using: [KeyPathComparator(\.askingState.nextRepetition, order: .forward)])
        async let notNewBaseAskingLearningValues = baseAskingLearningValues
            .filter{ $0.askingState.isNewly == false }
        
        async let newTranslationAskingLearningValues = translationAskingLearningValues
            .filter{ $0.askingState.isNewly }
            .sorted(using: [KeyPathComparator(\.askingState.nextRepetition, order: .forward)])
        async let notNewTranslationAskingLearningValues = translationAskingLearningValues
            .filter{ $0.askingState.isNewly == false }
        
        let notNewLearningValues = ( (await notNewBaseAskingLearningValues) + (await notNewTranslationAskingLearningValues) ).sorted(using: KeyPathComparator(\.askingState.nextRepetition, order: .forward))
        
        return (await newBaseAskingLearningValues) + (await newTranslationAskingLearningValues) + notNewLearningValues
    }
}
