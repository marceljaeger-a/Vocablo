//
//  SortDescriptor.swift
//  Vocablo
//
//  Created by Marcel Jäger on 13.03.24.
//

import Foundation
import SwiftData

extension SortDescriptor {
    static func decksSortDescriptor(by sortingKey: DecksSortingKey, order: SortingOrder) -> SortDescriptor<Deck> {
        switch sortingKey {
        case .createdDate:
            SortDescriptor<Deck>(\Deck.created, order: order.swiftDataOrder)
        case .name:
            SortDescriptor<Deck>(\Deck.name, order: order.swiftDataOrder)
        }
    }
    
    static func vocabularySortDescriptor(by sortingKey: VocabularySortingKey, order: SortingOrder) -> SortDescriptor<Vocabulary> {
        switch sortingKey {
        case .createdDate:
            SortDescriptor<Vocabulary>(\.created, order: order.swiftDataOrder)
        case .baseWord:
            SortDescriptor<Vocabulary>(\.baseWord, order: order.swiftDataOrder)
        case .translationWord:
            SortDescriptor<Vocabulary>(\.translationWord, order: order.swiftDataOrder)
        case .baseSentence:
            SortDescriptor<Vocabulary>(\.baseSentence, order: order.swiftDataOrder)
        case .translationSentence:
            SortDescriptor<Vocabulary>(\.translationSentence, order: order.swiftDataOrder)
        case .isToLearn:
            SortDescriptor<Vocabulary>(\.isToLearn, order: order.swiftDataOrder)
        }
    }
}
