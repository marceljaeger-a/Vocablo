//
//  LearnValueManager.swift
//  Vocablo
//
//  Created by Marcel Jäger on 15.12.23.
//

import Foundation

struct LearningValueManager {
    
    //MARK: - Instanz Properties
    
    ///Returns a calculated Array of LearningValue instances by an algorythm.
    /// - 1. New Vocabularies with base word as asking word.
    /// - 2. New Vocabularies with translation word as asking word.
    /// - 3. Repeating Vocabularies sorted by the next repetition date.
    func algorithmedLearningValues(of vocabularies: Array<Vocabulary>) -> Array<LearningValue> {
        //1 Newly
        let newlyFilters: Array<(LearningValue) -> Bool> = [{ $0.learnableObject.isToLearn }, { $0.askingState.isNewly }, { $0.askingState.isNextRepetitionExpired }]
        
        //1.1 Newly with base word
        let newlyLearningValuesWithWord = learningValues(of: vocabularies, asking: .base, filters: newlyFilters, sorting: KeyPathComparator(\.askingState.nextRepetition))
        
        //1.2 Newly with translation word
        let newlyLearningValuesWithTranslatedWord = learningValues(of: vocabularies, asking: .translation, filters: newlyFilters, sorting: KeyPathComparator(\.askingState.nextRepetition))
        
        
        
        //2 Repeatly
        let repeatlyFilters: Array<(LearningValue) -> Bool> = [{ $0.learnableObject.isToLearn }, { $0.askingState.isRepeatly }, { $0.askingState.isNextRepetitionExpired }]
        
        //2.1 Repeatly with base word
        let repeatlyLeaningValuesWithWord = learningValues(of: vocabularies, asking: .base, filters: repeatlyFilters)
        
        //2.2 Repeatly with translation word
        let repeatlyLeaningValuesWithTranslatedWord = learningValues(of: vocabularies, asking: .translation, filters: repeatlyFilters)
        
        //2.3 Repeatly combined
        let repeatlyLearningValuesCombined = repeatlyLeaningValuesWithWord + repeatlyLeaningValuesWithTranslatedWord
        
        let repeatlyLearnValuesCombinedSorted = repeatlyLearningValuesCombined.sorted(using: KeyPathComparator(\.askingState.nextRepetition))
        
        
        
        //3 Combined in right sorting
        //- 1. Newly with base word
        //- 2. Newly with translation word
        //- 3. Repeatly combined
        let combinedLearningValues = newlyLearningValuesWithWord + newlyLearningValuesWithTranslatedWord + repeatlyLearnValuesCombinedSorted
        
        return combinedLearningValues
    }
    
    ///Returns the count of the algorithmedLearningValues.
    func algorithmedLearningValuesCount(of vocabularies: Array<Vocabulary>) -> Int {
        algorithmedLearningValues(of: vocabularies).count
    }
    
    //MARK: - Instanz Methodes
    
    ///Returns an Array of LearningValue instances with the managingList´s vocabularies sorted and filtered by the filsters and sorting parameter.
    private func learningValues(of vocabularies: Array<Vocabulary>, asking: LearningValue.AskingLearningContent, filters: Array<(LearningValue) -> Bool >, sorting: KeyPathComparator<LearningValue>? = nil) -> Array<LearningValue> {
        var values = vocabularies.map { element in
           LearningValue(learnableObject: element, asking: asking)
        }
        
        for filter in filters {
            values = values.filter(filter)
        }
        
        if let sortingComparator = sorting {
            return values.sorted(using: sortingComparator)
        }else {
            return values
        }
    }
}
