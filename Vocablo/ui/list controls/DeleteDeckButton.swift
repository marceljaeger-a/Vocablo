//
//  DeleteListButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 04.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct DeleteDeckButton<LabelContent: View>: View {
    
    //MARK: - Dependencies
    
    let deck: Deck?
    @Binding var selectedDeckValue: DeckSelectingValue
    var label: () -> LabelContent
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Initialiser
    
    init(
        deck: Deck?,
        selectedDeckValue: Binding<DeckSelectingValue>,
        label: @escaping () -> LabelContent = { Label("Delete", systemImage: "trash") }
    ) {
        self.deck = deck
        self._selectedDeckValue = selectedDeckValue
        self.label = label
    }
    
    //MARK: - Methods
    
    private func perform() {
        guard let deck else { return }
        
        modelContext.delete(models: [deck])
        
        if let selectedListModel = selectedDeckValue.deck {
            if deck.id == selectedListModel.id {
                selectedDeckValue = .all
            }
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
