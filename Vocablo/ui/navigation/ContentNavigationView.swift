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
    @State private var selectedList: ListSelectingValue = .all
    
    @AppStorage(AppStorageKeys.listSortingKey) var listSortingKey: ListSortingKey = .createdDate
    @AppStorage(AppStorageKeys.listSortingOrder) var listSortingOrder: SortingOrder = .ascending
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        NavigationSplitView {
            Sidebar(selectedList: $selectedList, listSortingKey: listSortingKey, listSortingOrder: listSortingOrder)
                .navigationSplitViewColumnWidth(min: 200, ideal: 250)
        } detail: {
            Detail(selectedList: $selectedList)
        }
        .navigationTitle("")
        .searchable(text: $searchingText, prompt: Text("Search for word or sentence"))
        .environment(\.searchingText, searchingText)
        .onAppear { modelContext.undoManager = viewUndoManager }
        .modifier(CopyableVocabuariesModifier())
        .modifier(CuttableVocabulariesModifier())
        .modifier(PasteVocabulariesModifier(selectedList: selectedList))
    }
}


