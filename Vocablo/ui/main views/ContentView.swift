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
    @Query private var allVocabularies: Array<Vocabulary>
    
    //MARK: - Body
    
    var body: some View {
        NavigationSplitView {
            SidebarView(learningList: $learningList)
                .navigationSplitViewColumnWidth(min: 200, ideal: 250)
        } detail: {
            if learningList == nil {
                
                if let firstSelectedList: VocabularyList = context.fetch(by: selections.selectedListIdentifiers).first {
                    //DetailView(selectedList: firstSelectedList, learningList: $learningList)
                    VocabularyListDetailView(of: firstSelectedList, learningList: $learningList)
                } else {
                    NoSelectedListView()
                }
                
            }
        }
        .navigationTitle("")
        .linkContextUndoManager(context: context, with: viewUndoManager)
        .copyableVocabularies(context.fetch(by: selections.selectedVocabularyIdentifiers))
        .cuttableVocabularies(context.fetch(by: selections.selectedVocabularyIdentifiers), context: context)
        .vocabulariesPasteDestination(into: context.fetch(by: selections.selectedListIdentifiers).first, context: context)
        .onDeleteCommand { //⌫ & Delete Menu command, when no vocabulary is selected.
            context.deleteVocabularies(
                allVocabularies[
                    byIdentifiers: selections.unselectAllVocabularies()
                ]
            )
        }
        .onChange(of: selections.selectedListIdentifiers) {
            _ = selections.unselectAllVocabularies()
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

