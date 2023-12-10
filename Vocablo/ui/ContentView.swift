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
    
    @Binding var selectedListIDs: Set<PersistentIdentifier>
    @Binding var selectedVocabularyIDs: Set<PersistentIdentifier>
    @Binding var showLearningSheet: Bool

    @State var showContextSaveErrorAlert: Bool = false
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selectedListIDs: $selectedListIDs)
        } detail: {
            if let firstSelectedList: VocabularyList = context.fetch(ids: selectedListIDs).first {
                VocabularyListView(list: firstSelectedList, selectedVocabularyIDs: $selectedVocabularyIDs, showLearningSheet: $showLearningSheet)
            } else {
                ContentUnavailableView("No selected list!", systemImage: "book.pages", description: Text("Select a list on the sidebar."))
            }
        }
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
        .toolbar {
            ToolbarItem(placement: .secondaryAction) {
                Button {
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                        showContextSaveErrorAlert = true
                    }
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .symbolEffect(.pulse , options: .repeating.speed(3), isActive: context.hasChanges)
                }
            }
        }
        .alert("Save failed!", isPresented: $showContextSaveErrorAlert) {
            Button {
                showContextSaveErrorAlert = false
            } label: {
                Text("Ok")
            }
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


