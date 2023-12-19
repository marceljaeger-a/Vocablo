//
//  LearnValueManager.swift
//  Vocablo
//
//  Created by Marcel Jäger on 15.12.23.
//

import Foundation

struct LearningValueManager {
    
    //MARK: - Instanz Properties
    
    let managingList: VocabularyList
    
    ///Returns the vocabularies of the managingList.
    private var managingVocabularies: Array<Vocabulary> {
        managingList.vocabularies
    }
    
    ///Returns a calculated Array of LearningValue instances by an algorythm.
    /// - 1. New Vocabularies with word as asking.
    /// - 2. New Vocabularies with translated word as asking.
    /// - 3. Repeating Vocabularies sorted by the next repetition date.
    var algorithmedLearnSideValues: Array<LearningValue> {
        //1 Newly
        let newlyFilters: Array<(LearningValue) -> Bool> = [{ $0.learnableObject.isToLearn }, { $0.state.isNewly }, { $0.state.isNextRepetitionExpired }]
        
        //1.1 Newly with word
        let newlyLearningValuesWithWord = learningValues(asking: .word, filters: newlyFilters, sorting: KeyPathComparator(\.state.nextRepetition))
        
        //1.2 Newly with translated word
        let newlyLearningValuesWithTranslatedWord = learningValues(asking: .translatedWord, filters: newlyFilters, sorting: KeyPathComparator(\.state.nextRepetition))
        
        
        
        //2 Repeatly
        let repeatlyFilters: Array<(LearningValue) -> Bool> = [{ $0.learnableObject.isToLearn }, { $0.state.isRepeatly }, { $0.state.isNextRepetitionExpired }]
        
        //2.1 Repeatly with word
        let repeatlyLeaningValuesWithWord = learningValues(asking: .word, filters: repeatlyFilters)
        
        //2.2 Repeatly with translated word
        let repeatlyLeaningValuesWithTranslatedWord = learningValues(asking: .translatedWord, filters: repeatlyFilters)
        
        //2.3 Repeatly combined
        let repeatlyLearningValuesCombined = repeatlyLeaningValuesWithWord + repeatlyLeaningValuesWithTranslatedWord
        
        let repeatlyLearnValuesCombinedSorted = repeatlyLearningValuesCombined.sorted(using: KeyPathComparator(\.state.nextRepetition))
        
        
        
        //3 Combined in right sorting
        //- 1. Newly with word
        //- 2. Newly with translated word
        //- 3. Repeatly combined
        let combinedLearningValues = newlyLearningValuesWithWord + newlyLearningValuesWithTranslatedWord + repeatlyLearnValuesCombinedSorted
        
        return combinedLearningValues
    }
    
    //MARK: - Instanz Methodes
    
    ///Returns an Array of LearningValue instances with the managingList´s vocabularies sorted and filtered by the filsters and sorting parameter.
    private func learningValues(asking: LearningValue.AskedWord, filters: Array<(LearningValue) -> Bool >, sorting: KeyPathComparator<LearningValue>? = nil) -> Array<LearningValue> {
       var values = managingVocabularies.map { element in
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
