//
//  VocabularySorting.swift
//  Vocablo
//
//  Created by Marcel Jäger on 12.03.24.
//

import Foundation

enum VocabularySortingKey: Int, CaseIterable {
    case createdDate
    case baseWord
    case translationWord
    case baseSentence
    case translationSentence
    case isToLearn
    
    var label: String {
        switch self {
        case .createdDate:
            "Date created"
        case .baseWord:
            "Word"
        case .translationWord:
            "Word translation"
        case .baseSentence:
            "Sentence"
        case .translationSentence:
            "Sentence translation"
        case .isToLearn:
            "Is to learn"
        }
    }
}
