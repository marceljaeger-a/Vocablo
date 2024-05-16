//
//  VocabularyListItem.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.02.24.
//

import Foundation
import SwiftUI
import SwiftData

struct DeckRow: View {
    let deck: Deck
    
    var body: some View {
        let _ = Self._printChanges()
        Label(deck.name, systemImage: "book.pages")
    }
}
