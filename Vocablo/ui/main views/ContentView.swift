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
    
    @Environment(\.selectionContext) private var selectionContext: SelectionContext
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Environment(\.sheetContext) private var sheetContext
    @Environment(\.undoManager) private var viewUndoManager: UndoManager?
    
    @Query(sort: \VocabularyList.created, order: .forward) private var allLists: Array<VocabularyList>
    @Query private var allVocabularies: Array<Vocabulary>
    
    let duplicatesRecognizer = DuplicateRecognitionService()
    
    //MARK: - Body
    
    var body: some View {
        NavigationSplitView {
            SidebarView()
                .navigationSplitViewColumnWidth(min: 200, ideal: 250)
        } detail: {
            if sheetContext.learningVocabularies == nil {
    
                if selectionContext.listSelections.isAllVocabulariesSelected {
                    VocabularyListDetailView(of: nil, isShown: nil, isDuplicatesPopoverButtonAvailable: true, isListLabelAvailable: true)
                }else if selectionContext.listSelections.isDuplicatesSelected {
                    VocabularyListDetailView(of: nil, isShown: { duplicatesRecognizer.existDuplicate(of: $0, within: allVocabularies)}, isDuplicatesPopoverButtonAvailable: false, isListLabelAvailable: true)
                } else if selectionContext.listSelections.isAnyListSelected, let firstSelectedList: VocabularyList = modelContext.fetch(by: selectionContext.listSelections.listIdentifiers ?? []).first {
                    VocabularyListDetailView(of: firstSelectedList, isShown: nil, isDuplicatesPopoverButtonAvailable: true, isListLabelAvailable: false)
                } else {
                    NoSelectedListView()
                }
                
            }
        }
        .navigationTitle("")
        .linkContextUndoManager(context: modelContext, with: viewUndoManager)
        .copyableVocabularies(modelContext.fetch(by: selectionContext.selectedVocabularyIdentifiers))
        .cuttableVocabularies(modelContext.fetch(by: selectionContext.selectedVocabularyIdentifiers), context: modelContext)
        .vocabulariesPasteDestination(into: modelContext.fetch(by: selectionContext.listSelections.listIdentifiers ?? []).first, context: modelContext)
        .onDeleteCommand { //⌫ & Delete Menu command, when no vocabulary is selected.
            modelContext.deleteVocabularies(
                allVocabularies[
                    byIdentifiers: selectionContext.unselectAllVocabularies()
                ]
            )
        }
        .onChange(of: selectionContext.listSelections.selections) {
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
    ContentView()
        .previewModelContainer()
}

