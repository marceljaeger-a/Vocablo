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
    func algorithmedLearningValues(of managingList: VocabularyList) -> Array<LearningValue> {
        //1 Newly
        let newlyFilters: Array<(LearningValue) -> Bool> = [{ $0.learnableObject.isToLearn }, { $0.askingState.isNewly }, { $0.askingState.isNextRepetitionExpired }]
        
        //1.1 Newly with base word
        let newlyLearningValuesWithWord = learningValues(of: managingList, asking: .base, filters: newlyFilters, sorting: KeyPathComparator(\.askingState.nextRepetition))
        
        //1.2 Newly with translation word
        let newlyLearningValuesWithTranslatedWord = learningValues(of: managingList, asking: .translation, filters: newlyFilters, sorting: KeyPathComparator(\.askingState.nextRepetition))
        
        
        
        //2 Repeatly
        let repeatlyFilters: Array<(LearningValue) -> Bool> = [{ $0.learnableObject.isToLearn }, { $0.askingState.isRepeatly }, { $0.askingState.isNextRepetitionExpired }]
        
        //2.1 Repeatly with base word
        let repeatlyLeaningValuesWithWord = learningValues(of: managingList, asking: .base, filters: repeatlyFilters)
        
        //2.2 Repeatly with translation word
        let repeatlyLeaningValuesWithTranslatedWord = learningValues(of: managingList, asking: .translation, filters: repeatlyFilters)
        
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
    func algorithmedLearningValuesCount(of managingList: VocabularyList) -> Int {
        algorithmedLearningValues(of: managingList).count
    }
    
    //MARK: - Instanz Methodes
    
    ///Returns an Array of LearningValue instances with the managingList´s vocabularies sorted and filtered by the filsters and sorting parameter.
    private func learningValues(of managingList: VocabularyList, asking: LearningValue.AskingLearningContent, filters: Array<(LearningValue) -> Bool >, sorting: KeyPathComparator<LearningValue>? = nil) -> Array<LearningValue> {
        var values = managingList.vocabularies.map { element in
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
