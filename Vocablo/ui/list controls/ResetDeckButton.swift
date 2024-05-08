//
//  ResetListButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 04.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct ResetDeckButton<LabelContent: View>: View {
    
    //MARK: - Dependencies
    
    let deck: Deck?
    var label: () -> LabelContent
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Initialiser
    
    init(
        deck: Deck?,
        label: @escaping () -> LabelContent = { Text("Reset") }
    ) {
        self.deck = deck
        self.label = label
    }
    
    //MARK: - Methods
    
    private func perform() {
        guard let deck else { return }
        let fetchedVocabulariesOfList = modelContext.fetchVocabularies(.vocabularies(of: deck))
        fetchedVocabulariesOfList.forEach { vocabulary in
            vocabulary.reset()
        }
    }
    
    //MARK: - Body
    
    var body: some View {
        Button {
            perform()
        } label: {
            label()
        }
    }
}
