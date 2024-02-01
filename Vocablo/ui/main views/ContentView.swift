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
    
    @Environment(\.selectionContext) private var selectionContext: SelectionContext
    @Environment(\.modelContext) private var modelContext: ModelContext
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
                
                if let firstSelectedList: VocabularyList = modelContext.fetch(by: selectionContext.selectedListIdentifiers).first {
                    VocabularyListDetailView(of: firstSelectedList, learningList: $learningList, isDuplicatesPopoverButtonAvailable: true, isListLabelAvailable: false)
                } else {
                    NoSelectedListView()
                }
                
            }
        }
        .navigationTitle("")
        .linkContextUndoManager(context: modelContext, with: viewUndoManager)
        .copyableVocabularies(modelContext.fetch(by: selectionContext.selectedVocabularyIdentifiers))
        .cuttableVocabularies(modelContext.fetch(by: selectionContext.selectedVocabularyIdentifiers), context: modelContext)
        .vocabulariesPasteDestination(into: modelContext.fetch(by: selectionContext.selectedListIdentifiers).first, context: modelContext)
        .onDeleteCommand { //⌫ & Delete Menu command, when no vocabulary is selected.
            modelContext.deleteVocabularies(
                allVocabularies[
                    byIdentifiers: selectionContext.unselectAllVocabularies()
                ]
            )
        }
        .onChange(of: selectionContext.selectedListIdentifiers) {
            _ = selectionContext.unselectAllVocabularies()
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

