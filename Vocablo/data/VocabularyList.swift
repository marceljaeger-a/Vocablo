//
//  VocabularyList.swift
//  Vocablo
//
//  Created by Marcel Jäger on 23.10.23.
//

import Foundation
import SwiftData

@Model
class VocabularyList {
    var name: String
    var created: Date
    
    @Relationship(deleteRule: .nullify, inverse: \Vocabulary.list) var vocabularies: Array<Vocabulary>
    
    init(_ name: String, vocabularies: Array<Vocabulary> = []) {
        self.name = name
        self.created = Date.now
        self.vocabularies = vocabularies
    }
}

extension VocabularyList {
    func addVocabulary(_ vocabulary: Vocabulary) {
        self.vocabularies.append(vocabulary)
    }
    
    func containVocabulary(_ vocabulary: Vocabulary) -> Bool {
        self.vocabularies.contains { item in
            item == vocabulary
        }
    }
    
    func removeVocabulary(_ vocabulary: Vocabulary) {
        self.vocabularies.removeAll { element in
            element == vocabulary
        }
    }
}

extension VocabularyList {
    typealias LearningWrappedVocabulary = (Learnable, isReverse: Bool)
    
    var learningVocabulariesToday: Array<LearningWrappedVocabulary> {
        //Algorytm
        //1. Newly before Repeatly
        //1.1 Newly: Normal before Reverse
        //1.1.1 nextRepetition sorting
        //1.2 Repeatly: nextRepetition sorting
        
        //All Vocabularies and sort it to learnable Vocabularies
        let vocabularies = vocabularies.filter{ $0.isLearnable }
        
        //Newly Vocabularies
        let newlyVocabularies = vocabularies.filter{ $0.learningState.isNewly && $0.learningState.isNextRepetitionExpired
        }.map {
            return ($0, isReverse: false)
        }.sorted(using: KeyPathComparator(\.0.learningState.nextRepetition))
        
        let newlyReverseVocabularies = vocabularies.filter {
            $0.translatedLearningState.isNewly && $0.translatedLearningState.isNextRepetitionExpired
        }.map {
            return ($0, isReverse: true)
        }.sorted(using: KeyPathComparator(\.0.translatedLearningState.nextRepetition))
        
        //Repeatly Vocabularies
        let repeatlyVocabularies = vocabularies.filter {
            $0.learningState.isRepeatly && $0.learningState.isNextRepetitionExpired
        }.map {
            return ($0, isReverse: false)
        }
        
        let repeatlyReverseVocabularies = vocabularies.filter {
            $0.translatedLearningState.isRepeatly && $0.translatedLearningState.isNextRepetitionExpired
        }.map {
            return ($0, isReverse: true)
        }
        
        let allRepeatlyVocabularies = (repeatlyVocabularies + repeatlyReverseVocabularies).sorted { firstVocabulary, secondVocabulary in
            
            let firstVocabularyNextRepetition: Date
            switch firstVocabulary {
            case (let vocabulary, false):
                firstVocabularyNextRepetition = vocabulary.learningState.nextRepetition
            case (let vocabulary, true):
                firstVocabularyNextRepetition = vocabulary.translatedLearningState.nextRepetition
            }
            
            let secondVocabularyNextRepetition: Date
            switch secondVocabulary {
            case (let vocabulary, false):
                secondVocabularyNextRepetition = vocabulary.learningState.nextRepetition
            case (let vocabulary, true):
                secondVocabularyNextRepetition = vocabulary.translatedLearningState.nextRepetition
            }
            
            if firstVocabularyNextRepetition <= secondVocabularyNextRepetition {
                return true
            }else {
                return false
            }
        }
        
        //Combine all learnable Vocabularies
        let allVocabularies = newlyVocabularies + newlyReverseVocabularies + allRepeatlyVocabularies
        
        return allVocabularies
    }
    
    var learningVocabulariesTodayCount: Int {
        learningVocabulariesToday.count
    }
}


