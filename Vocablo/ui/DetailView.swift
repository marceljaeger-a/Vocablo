//
//  VocabularyListView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 27.11.23.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @Bindable var list: VocabularyList
    @Binding var selectedVocabularyIDs: Set<PersistentIdentifier>
    @Binding var showLearningSheet: Bool
    
    @Environment(\.modelContext) var context: ModelContext
    @Query var vocabularies: Array<Vocabulary>
    @State var editingVocabulary: Vocabulary?
    @FocusState private var textFieldFocus: VocabularyTextFieldFocusState?
    
    var filteredVocabularies: Array<Vocabulary> {
        vocabularies
            .filter { element in
                element.list == list
            }
            .sorted(using: list.sorting.sortComparator)
    }
    
    var body: some View {
        VocabularyListView(vocabularies: filteredVocabularies, selection: $selectedVocabularyIDs, textFieldFocus: $textFieldFocus, onSubmitAction: list.addNewVocabulary)
        .contextMenu(forSelectionType: Vocabulary.ID.self, menu: { vocabularyIDs in
            if vocabularyIDs.isEmpty {
                Button {
                    list.addNewVocabulary()
                } label: {
                    Text("New vocabulary")
                }
            }else {
                if vocabularyIDs.count == 1 {
                    Button {
                        guard let firstVocabulary: Vocabulary = context.fetch(ids: vocabularyIDs).first else { return }
                        openEditVocabularyView(for: firstVocabulary)
                    } label: {
                        Text("Edit")
                    }
                    
                    Divider()
                }
                
                Button {
                    context.toLearn(for: context.fetch(ids: vocabularyIDs))
                } label: {
                    Text("To learn")
                }
            
                Button {
                    context.notToLearn(for: context.fetch<Vocabulary>(ids: vocabularyIDs))
                } label: {
                    Text("Not to learn")
                }
                
                Button {
                    context.resetVocabularies(context.fetch(ids:vocabularyIDs))
                } label: {
                    if vocabularyIDs.count == 1 {
                        Text("Reset")
                    }else {
                        Text("Reset selected")
                    }
                }
                
                Divider()
                
                Button {
                    context.deleteVocabularies(context.fetch(ids: vocabularyIDs))
                } label: {
                    if vocabularyIDs.count == 1 {
                        Text("Delete")
                    }else {
                        Text("Delete selected")
                    }
                }
            }
        }, primaryAction: { vocabularyIDs in
            if vocabularyIDs.count == 1 {
                guard let firstVocabulary: Vocabulary = context.fetch(ids: vocabularyIDs).first else { return }
                openEditVocabularyView(for: firstVocabulary)
            }
        })
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button {
                    self.showLearningSheet = true
                } label: {
                    Image(.wordlistPlay)
                }
            }
            
            ToolbarItemGroup(placement: .primaryAction) {
                Spacer()
                
                Button {
                    list.addNewVocabulary()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showLearningSheet, content: {
            LearnView(list: list)
        })
        .sheet(item: $editingVocabulary) { vocabulary in
            EditVocabularyView(vocabulary: vocabulary)
        }
        .onAddVocabulary(to: list) { newVocabulary in
            onAddVocabulary(vocabulary: newVocabulary)
        }
    }
    
    private func onAddVocabulary(vocabulary: Vocabulary) {
        textFieldFocus = nil //This helps for the "AttributeGraph" message!
        selectedVocabularyIDs = []
        selectedVocabularyIDs.insert(vocabulary.id) //This causes an "AttributeGraph" message!
        Task { //This helps for the nonfocsuing, when an other list is focued, while I add a new list.
            textFieldFocus = .word(vocabulary.id)
        }
    }
    
    private func openEditVocabularyView(for vocabulary: Vocabulary) {
        editingVocabulary = vocabulary
    }
}



#Preview {
    DetailView( list: VocabularyList("Preview List"), selectedVocabularyIDs: .constant([]), showLearningSheet: .constant(false))
}

