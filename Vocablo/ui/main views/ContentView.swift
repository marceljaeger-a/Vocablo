//
//  PackNavigationView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 24.10.23.
//

import SwiftUI
import SwiftData

//struct ContentView: View {
//    
//    //MARK: - Properties
//    
//    @Environment(\.selectionContext) private var selectionContext: SelectionContext
//    @Environment(\.modelContext) private var modelContext: ModelContext
//    @Environment(\.undoManager) private var viewUndoManager: UndoManager?
//    
//    @State var searchingText: String = ""
//    
//    //MARK: - Body
//    
//    var body: some View {
//        NavigationSplitView {
//            SidebarView()
//                .navigationSplitViewColumnWidth(min: 200, ideal: 250)
//        } detail: {
//            DetailView()
//        }
//        .navigationTitle("")
//        .searchable(text: $searchingText, prompt: Text("Search for word or sentence"))
//        .environment(\.searchingText, searchingText)
//        .linkContextUndoManager(context: modelContext, with: viewUndoManager)
//        .copyableVocabularies(modelContext.fetchVocabularies(.byIdentifiers(selectionContext.selectedVocabularyIdentifiers)))
//        .cuttableVocabularies(modelContext.fetchVocabularies(.byIdentifiers(selectionContext.selectedVocabularyIdentifiers)), context: modelContext)
//        .vocabulariesPasteDestination(into: modelContext.fetchLists(.byIdentifiers(selectionContext.listSelections.listIdentifiers ?? [])).first, context: modelContext)
//        .onDeleteCommand { //⌫ & Delete Menu command, when no vocabulary is selected.
//            let selectedIdentifiers = selectionContext.unselectAllVocabularies()
//            let deletingVocabularies = modelContext.fetchVocabularies(.byIdentifiers(selectedIdentifiers))
//            modelContext.delete(models: deletingVocabularies)
//            
////            Possibility 2 with a special methode because of the UndoManager!
////            modelContext.delete(model: Vocabulary.self, where: #Predicate { selectedIdentifiers.contains($0.persistentModelID) })
//        }
//        .onChange(of: selectionContext.listSelections.selections) {
//            _ = selectionContext.unselectAllVocabularies()
//        }
//    }
//}
//
//
//
////MARK: - Subviews
//extension ContentView {
//    struct NoSelectedListView: View {
//        var body: some View {
//            ContentUnavailableView("No selected list!", systemImage: "book.pages", description: Text("Select a list on the sidebar."))
//        }
//    }
//    
//    struct DetailView: View {
//        @Environment(\.modelContext) private var modelContext: ModelContext
//        @Environment(\.selectionContext) private var selectionContext: SelectionContext
//        @Environment(\.sheetContext) private var sheetContext
//        
//        @Environment(\.searchingText) private var searchingText: String
//        @Environment(\.isSearching) var isSearching: Bool
//        
//        var body: some View {
//            if sheetContext.learningVocabularies == nil {
//                if isSearching {
//                    VocabularyListDetailView(
//                        of: nil,
//                        isShown:
//                            {
//                                $0.baseWord.lowercased().contains(searchingText.lowercased())
//                                || $0.baseSentence.lowercased().contains(searchingText.lowercased())
//                                || $0.translationWord.lowercased().contains(searchingText.lowercased())
//                                || $0.translationSentence.lowercased().contains(searchingText.lowercased())
//                            },
//                        isDuplicatesPopoverButtonAvailable: true,
//                        isListLabelAvailable: true)
//                    .navigationTitle("Searching results")
//                }else if selectionContext.listSelections.isAllVocabulariesSelected {
//                    VocabularyListDetailView(of: nil, isShown: nil, isDuplicatesPopoverButtonAvailable: true, isListLabelAvailable: true)
//                }else if selectionContext.listSelections.isDuplicatesSelected {
////                    VocabularyListDetailView(of: nil, isShown: { duplicatesRecognizer.existDuplicate(of: $0, within: allVocabularies)}, isDuplicatesPopoverButtonAvailable: false, isListLabelAvailable: true)
//                } else if selectionContext.listSelections.isAnyListSelected, let firstSelectedList = modelContext.fetchLists(.byIdentifiers( selectionContext.listSelections.listIdentifiers ?? [])).first {
//                    VocabularyListDetailView(of: firstSelectedList, isShown: nil, isDuplicatesPopoverButtonAvailable: true, isListLabelAvailable: false)
//                } else {
//                    NoSelectedListView()
//                }
//            }
//        }
//    }
//}
//
//
//
////MARK: - Preview
//
//#Preview {
//    ContentView()
//        .previewModelContainer()
//}

