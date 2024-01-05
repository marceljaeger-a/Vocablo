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
    @Binding var learningList: VocabularyList?
    
    @Environment(\.selections) private var selections: SelectionContext
    @Environment(\.modelContext) private var context: ModelContext
    @Environment(\.undoManager) private var viewUndoManager: UndoManager? 
    @Query(sort: \VocabularyList.created, order: .forward) private var allLists: Array<VocabularyList>
  
    //MARK: - Methodes
    
    private func deleteSelectedVocabularies() {
        guard context.fetchVocabularyCount(by: selections.selectedVocabularyIdentifiers) > 0 else { return }
        context.deleteVocabularies(context.fetch(by: selections.selectedVocabularyIdentifiers))
    }
    
    //MARK: - Body
    
    var body: some View {
        NavigationSplitView {
            SidebarView(learningList: $learningList)
                .navigationSplitViewColumnWidth(min: 200, ideal: 250)
        } detail: {
            
            if let firstSelectedList: VocabularyList = context.fetch(by: selections.selectedListIdentifiers).first {
                DetailView(selectedList: firstSelectedList, learningList: $learningList)
            } else {
                NoSelectedListView()
            }
    
        }
        .navigationTitle("")
        .linkContextUndoManager(context: context, with: viewUndoManager)
        .copyableVocabularies(context.fetch(by: selections.selectedVocabularyIdentifiers))
        .cuttableVocabularies(context.fetch(by: selections.selectedVocabularyIdentifiers), context: context)
        .vocabulariesPasteDestination(into: context.fetch(by: selections.selectedListIdentifiers).first)
        .onDeleteCommand { //⌫ & Delete Menu command, when no vocabulary is selected.
            deleteSelectedVocabularies()
        }
        .onChange(of: selections.selectedListIdentifiers) {
            selections.selectedVocabularyIdentifiers = []
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
    ContentView(learningList: .constant(nil))
        .previewModelContainer()
}

