//
//  PackNavigationView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 24.10.23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var context: ModelContext
    @Environment(\.undoManager) var undoManager: UndoManager?
    @Query(sort: \VocabularyList.created, order: .forward) var lists: Array<VocabularyList>
    
    @Binding var selectedListIDs: Set<PersistentIdentifier>
    @Binding var selectedVocabularyIDs: Set<PersistentIdentifier>
    @Binding var showLearningSheet: Bool
  
    var body: some View {
        NavigationSplitView {
            SidebarView(selectedListIDs: $selectedListIDs)
                .navigationSplitViewColumnWidth(min: 200, ideal: 250)
        } detail: {
            if let firstSelectedList: VocabularyList = context.fetch(ids: selectedListIDs).first {
                VocabularyListView(list: firstSelectedList, selectedVocabularyIDs: $selectedVocabularyIDs, showLearningSheet: $showLearningSheet)
            } else {
                ContentUnavailableView("No selected list!", systemImage: "book.pages", description: Text("Select a list on the sidebar."))
            }
        }
        .linkContextUndoManager(context: context, with: undoManager)
        .navigationTitle("")
        .onDeleteCommand(perform: {
            guard context.fetchVocabularyCount(ids: selectedVocabularyIDs) > 0 else { return }
            context.deleteVocabularies(context.fetch(ids: selectedVocabularyIDs))
        })
        .copyableVocabularies(context.fetch(ids: selectedVocabularyIDs))
        .cuttableVocabularies(context.fetch(ids: selectedVocabularyIDs), context: context)
        .vocabularyiesPasteDestination(into: context.fetch(ids: selectedListIDs).first)
        .onChange(of: selectedListIDs) {
            selectedVocabularyIDs = []
        }
    }
}

#Preview {
    ContentView(selectedListIDs: .constant([]), selectedVocabularyIDs: .constant([]), showLearningSheet: .constant(false))
        .previewModelContainer()
}

extension View {
    func previewModelContainer() -> some View {
        self.modelContainer(for: [VocabularyList.self, Vocabulary.self, Tag.self], inMemory: true)
    }
}


