//
//  ContentNavigationView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 28.02.24.
//

import Foundation
import SwiftUI
import SwiftData

struct ContentNavigationView: View {
    
    //MARK: - Dependencies
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.undoManager) private var  viewUndoManager: UndoManager?
    
    @State private var searchingText: String = ""
    @State private var selectedDeckValue: DeckSelectingValue = .all
    
    @AppStorage(AppStorageKeys.decksSortingKey) var decksSortingKey: DecksSortingKey = .createdDate
    @AppStorage(AppStorageKeys.decksSortingOrder) var decksSortingOrder: SortingOrder = .ascending
    
    @State var presentationModel: PresentationModel = PresentationModel()
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        NavigationSplitView {
            Sidebar(selectedDeckValue: $selectedDeckValue, decksSortingKey: decksSortingKey, decksSortingOrder: decksSortingOrder)
                .navigationSplitViewColumnWidth(min: 200, ideal: 250)
        } detail: {
            Detail(selectedDeckValue: $selectedDeckValue)
        }
        .navigationTitle("")
        .searchable(text: $searchingText, prompt: Text("Search for word or sentence"))
        .environment(\.searchingText, searchingText)
        .onAppear { modelContext.undoManager = viewUndoManager }
        .modifier(CopyableVocabuariesModifier())
        .modifier(CuttableVocabulariesModifier())
        .modifier(PasteVocabulariesModifier(selectedDeckValue: selectedDeckValue))
        .environment(presentationModel)
        .focusedValue(presentationModel)
    }
}



