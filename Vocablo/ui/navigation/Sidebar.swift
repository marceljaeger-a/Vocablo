//
//  Sidebar.swift
//  Vocablo
//
//  Created by Marcel Jäger on 28.02.24.
//

import Foundation
import SwiftUI
import SwiftData

struct Sidebar: View {
    
    //MARK: - Dependencies
    
    @Binding var selectedDeckValue: DeckSelectingValue
    
    @Query(sort: \Deck.created, order: .forward) private var  decks: Array<Deck>
    
    @Environment(\.modelContext) var modelContext
    @Environment(ModalPresentationModel.self) var modalPresentationModel
    
    //MARK: Initialiser
    
    init(selectedDeckValue: Binding<DeckSelectingValue>, decksSortingKey: DecksSortingKey, decksSortingOrder: SortingOrder) {
        self._selectedDeckValue = selectedDeckValue
        
        self._decks = Query(sort: [SortDescriptor<Deck>.decksSortDescriptor(by: decksSortingKey, order: decksSortingOrder)])
    }
    
    //MARK: - Body
    
    func fetchVocabulariesCount(of deck: Deck?) -> Int {
        do {
            if let deck {
                return try modelContext.fetchCount(.vocabularies(of: deck))
            }else {
                return try modelContext.fetchCount(.vocabularies())
            }
        } catch {
            return 0
        }
    }
    
    var body: some View {
        let _ = Self._printChanges()
        List(selection: $selectedDeckValue){
            #warning("LearningVocabulariesCountBadgeModifier causes less performance because of the Query!")
            Label("All vocabularies", systemImage: "tray.full")
                .modifier(LearningVocabulariesCountBadgeModifier(deckValue: .all))
                .badge(fetchVocabulariesCount(of: nil))
                .badgeProminence(.decreased)
                .tag(DeckSelectingValue.all)
            
            Section("Decks") {
                ForEach(decks) { deck in
                    #warning("LearningVocabulariesCountBadgeModifier causes less performance because of the Query!")
                    DeckRow(deck: deck)
                        .modifier(LearningVocabulariesCountBadgeModifier(deckValue: .deck(deck: deck)))
                        .badge(fetchVocabulariesCount(of: deck))
                        .badgeProminence(.decreased)
                        .tag(DeckSelectingValue.deck(deck: deck))
                }
            }
//            SidebarListsSection(lists: lists)
        }
        .contextMenu(forSelectionType: DeckSelectingValue.self) { values in
            SidebarContextMenu(values: values, selectedDeckValue: $selectedDeckValue)
        } primaryAction: { values in
            if let firstDeck = values.first?.deck {
                modalPresentationModel.showDeckDetailSheet(edit: firstDeck)
            }
        }
        .overlay(alignment: .bottomLeading) {
            AddNewDeckButton {
                Label("New deck", systemImage: "plus")
            }
            .buttonStyle(.plain)
            .padding()
        }
        .focusedSceneValue(\.selectedDeckValue, $selectedDeckValue)
        .modifier(DeckDetailSheetModifier())
    }
}



struct SidebarContextMenu: View {
    let values: Set<DeckSelectingValue>
    @Binding var selectedDeckValue: DeckSelectingValue
    @Environment(ModalPresentationModel.self) var modalPresentationModal
    
    var firstDeck: Deck? {
        return values.first?.deck
    }
    
    var body: some View {
        AddNewDeckButton()
            .disabled(values.isEmpty == false)
        
        Divider()
        
        Button {
            if let firstDeck {
                modalPresentationModal.showDeckDetailSheet(edit: firstDeck)
            }
        } label: {
            Text("Edit deck")
        }
        .disabled(values.isEmpty)
        
        LearnVocabulariesButton(selectedDeckValue: values.first)
        
        Divider()
        
        DecksSortingPicker()
        VocabularySortingPicker()
        
        Divider()
        
        ResetDeckButton(deck: firstDeck)
            .disabled(values.isEmpty || values.contains(.all) == true)
        
        DeleteDeckButton(deck: firstDeck, selectedDeckValue: $selectedDeckValue)
            .disabled(values.isEmpty || values.contains(.all) == true)
    }
}
