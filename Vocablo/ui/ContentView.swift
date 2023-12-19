//
//  PackNavigationView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 24.10.23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    //MARK: - Properties
    
    @Binding var selectedListIdentifiers: Set<PersistentIdentifier>
    @Binding var selectedVocabularyIdentifiers: Set<PersistentIdentifier>
    @Binding var isLearningSheetShowed: Bool
    
    @Environment(\.modelContext) private var context: ModelContext
    @Environment(\.undoManager) private var viewUndoManager: UndoManager?
    @Query(sort: \VocabularyList.created, order: .forward) private var allLists: Array<VocabularyList>
  
    //MARK: - Methodes
    
    private func deleteSelectedVocabularies() {
        guard context.fetchVocabularyCount(by: selectedVocabularyIdentifiers) > 0 else { return }
        context.deleteVocabularies(context.fetch(by: selectedVocabularyIdentifiers))
    }
    
    //MARK: - Body
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selectedListIdentifiers: $selectedListIdentifiers)
                .navigationSplitViewColumnWidth(min: 200, ideal: 250)
        } detail: {
            
            if let firstSelectedList: VocabularyList = context.fetch(by: selectedListIdentifiers).first {
                DetailView(selectedList: firstSelectedList, selectedVocabularyIdentifiers: $selectedVocabularyIdentifiers, isLearningSheetShowed: $isLearningSheetShowed)
            } else {
                NoSelectedListView()
            }
    
        }
        .navigationTitle("")
        .linkContextUndoManager(context: context, with: viewUndoManager)
        .copyableVocabularies(context.fetch(by: selectedVocabularyIdentifiers))
        .cuttableVocabularies(context.fetch(by: selectedVocabularyIdentifiers), context: context)
        .vocabulariesPasteDestination(into: context.fetch(by: selectedListIdentifiers).first)
        .onDeleteCommand {
            deleteSelectedVocabularies()
        }
        .onChange(of: selectedListIdentifiers) {
            selectedVocabularyIdentifiers = []
        }
    }
}



//MARK: - Subviews
extension ContentView {
    struct NoSelectedListView: View {
        var body: some View {
            ContentUnavailableView("No selected list!", systemImage: "book.pages", description: Text("Select a list on the sidebar."))
        }
    }
}



//MARK: - Preview

#Preview {
    ContentView(selectedListIdentifiers: .constant([]), selectedVocabularyIdentifiers: .constant([]), isLearningSheetShowed: .constant(false))
        .previewModelContainer()
}

