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
    @Query(sort: \VocabularyList.created, order: .forward) var lists: Array<VocabularyList>
    @Query(sort: \Vocabulary.word) var allVocabularies: Array<Vocabulary>
    
    @State var selectedListIDs: Set<PersistentIdentifier> = []
    var selectedLists: Array<VocabularyList> {
        lists.filter { list in
            selectedListIDs.contains(list.id)
        }
    }
    
    @State var selectedVocabularyIDs: Set<PersistentIdentifier> = []
    var selectedVocabularies: Array<Vocabulary> {
        allVocabularies.filter { item in
            selectedVocabularyIDs.contains(item.id)
        }
    }
    var selectedVocabularyTransfers: Array<Vocabulary.TransferType> {
        selectedVocabularies.map({ $0.transferType })
    }
    
    @State var showVocabulariesDeletingConfirmationDialog = false
    var vocabularyDeletingConfirmationDialogText: String {
        if selectedVocabularies.count > 1 {
            "Do you want to delete the selected vocabularies?"
        }else {
            "Do you want to delete the vocabulary?"
        }
    }
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selectedListIDs: $selectedListIDs)
        } detail: {
            if let firstSelectedList = selectedLists.first {
                VocabularyListView(list: firstSelectedList, selectedVocabularyIDs: $selectedVocabularyIDs, showVocabulariesDeletingConfirmationDialog: $showVocabulariesDeletingConfirmationDialog)
            } else {
                ContentUnavailableView("No selected list!", systemImage: "book.pages", description: Text("Select a list on the sidebar."))
            }
        }
        .navigationTitle("")
        .onDeleteCommand(perform: {
            guard selectedVocabularies.count > 0 else { return }
            showVocabulariesDeletingConfirmationDialog = true
        })
        .copyable(selectedVocabularyTransfers)
        .cuttable(for: Vocabulary.TransferType.self) {
            cutVocabularies()
        }
        .pasteDestination(for: Vocabulary.TransferType.self) { pastedValues in
            pasteVocabularies(pastedValues)
        }
        .deletingConfirmationDialog(isPresented: $showVocabulariesDeletingConfirmationDialog, title: vocabularyDeletingConfirmationDialogText, cancelAction: {
            showVocabulariesDeletingConfirmationDialog = false
        }, deletingAction: {
            context.deleteVocabularies(selectedVocabularies)
        })
    }
    
    private func cutVocabularies() -> Array<Vocabulary.TransferType> {
        guard let list = selectedLists.first else { return [] }
        let cuttedVocabularies = selectedVocabularies
        let cuttedVocabularyTransfers = cuttedVocabularies.map{ $0.transferType }
        
        for cuttedVocabulary in cuttedVocabularies {
            list.removeVocabulary(cuttedVocabulary)
            context.delete(cuttedVocabulary)
        }
        
        return cuttedVocabularyTransfers
    }
    
    private func pasteVocabularies(_ vocabularyTransfers: Array<Vocabulary.TransferType>) {
        guard let list = selectedLists.first else { return }
        for vocabularyTransfer in vocabularyTransfers{
            let pastedVocabulary = vocabularyTransfer.newObject
            list.addVocabulary(pastedVocabulary)
        }
    }
}

#Preview {
    ContentView()
        .previewModelContainer()
}

extension View {
    func previewModelContainer() -> some View {
        self.modelContainer(for: [VocabularyList.self, Vocabulary.self, Tag.self], inMemory: true)
    }
}


