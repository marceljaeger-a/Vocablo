//
//  ListSelectingValue.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.02.24.
//

import Foundation
import SwiftData

enum DeckSelectingValue: Hashable {
    case all
    case deck(deck: Deck)
    
    var deck: Deck? {
        return switch self {
        case .all:
            nil
        case .deck(let deck):
            deck
        }
    }
}
