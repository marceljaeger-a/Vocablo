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
    @State private var learningVocabularies: Array<Vocabulary> = []
    
    //MARK: - Methods
    
    
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        NavigationSplitView {
            Sidebar(selectedList: $selectedList)
                .navigationSplitViewColumnWidth(min: 200, ideal: 250)
        } detail: {
            Detail(selectedList: $selectedList)
        }
        .navigationTitle("")
        .searchable(text: $searchingText, prompt: Text("Search for word or sentence"))
        .environment(\.searchingText, searchingText)
        .onAppear { modelContext.undoManager = viewUndoManager }
    }
}
