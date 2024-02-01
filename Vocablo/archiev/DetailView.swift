//
//  VocabularyListView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 27.11.23.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    
    //MARK: - Properties
    
    @Bindable var selectedList: VocabularyList
    @Binding var learningList: VocabularyList?
    
    @Environment(\.selectionContext) private var  selections: SelectionContext
    @Environment(\.modelContext) private var context: ModelContext
    @Query private var allVocabularies: Array<Vocabulary>
    @State private var editingVocabulary: Vocabulary?
    @FocusState private var textFieldFocus: VocabularyTextFieldFocusState?
    
    @Query var filteredAndSortedVocabulariesOfSelectedList: Array<Vocabulary>
    
    init(selectedList: VocabularyList, learningList: Binding<VocabularyList?>) {
        self.selectedList = selectedList
        self._learningList = learningList
        
        let filteringListIdentifier = selectedList.persistentModelID
        let vocabulariesFilter = #Predicate<Vocabulary> { vocabulary in
            vocabulary.list?.persistentModelID == filteringListIdentifier
        }
        let vocabulariesFetchDescriptor = FetchDescriptor<Vocabulary>(predicate: vocabulariesFilter, sortBy: [selectedList.sorting.sortDescriptor])
        _filteredAndSortedVocabulariesOfSelectedList = Query(vocabulariesFetchDescriptor)
    }
    
    //MARK: - Methodes
    
    private func focusNewVocabulary(_ vocabulary: Vocabulary) {
        textFieldFocus = .word(vocabulary.id)
    }
    
    private func openEditVocabularyView(for vocabulary: Vocabulary) {
        editingVocabulary = vocabulary
    }
    
    private func showLearningSheet() {
        self.learningList = selectedList
    }
    
    private func contextMenuPrimaryAction(vocabularyIDs: Set<PersistentIdentifier>) {
        if vocabularyIDs.count == 1 {
            guard let firstVocabulary: Vocabulary = allVocabularies[byIdentifiers: vocabularyIDs].first else { return }
            openEditVocabularyView(for: firstVocabulary)
        }
    }
    
    private func deleteSelectedVocabularies(vocabularyIdentifiers: Set<PersistentIdentifier>) {
        _ = selections.unselectVocabularies(vocabularyIdentifiers)
        context.deleteVocabularies(allVocabularies[byIdentifiers: vocabularyIdentifiers])
    }
    
    //MARK: - Body
    
    var body: some View {
        List(selection: selections.bindable.selectedVocabularyIdentifiers) {
            ForEach(filteredAndSortedVocabulariesOfSelectedList, id: \.id) { vocabulary in
                VocabularyItem(vocabulary: vocabulary, textFieldFocus: $textFieldFocus, isDuplicateRecognitionLabelAvailable: true, isListLabelAvailable: false)
                    .onSubmit {
                        selectedList.addNewVocabulary()
                    }
            }
            .onDelete { indexSet in //Swipe & Delete menu command(not the keypress), when a vocabulary is selected.
                deleteSelectedVocabularies(vocabularyIdentifiers: filteredAndSortedVocabulariesOfSelectedList[indexSet].identifiers)
            }
        }
        .contextMenu(forSelectionType: Vocabulary.ID.self) { vocabularyIDs in
            contextMenuButtons(vocabularyIdentifiers: vocabularyIDs)
        } primaryAction: { vocabularyIdentifiers in
            contextMenuPrimaryAction(vocabularyIDs: vocabularyIdentifiers)
        }
        .toolbar {
            toolbarButtons
        }
        .sheet(item: $editingVocabulary) { vocabulary in
            EditVocabularyView(editingVocabulary: vocabulary)
        }
//        .onAddVocabulary(to: selectedList) { newVocabulary in
//            focusNewVocabulary(newVocabulary)
//        }
    }
}



//MARK: - Subviews

extension DetailView {
    @ViewBuilder 
    func contextMenuButtons(vocabularyIdentifiers: Set<PersistentIdentifier>) -> some View {
        Button {
            selectedList.addNewVocabulary()
        } label: {
            Text("New vocabulary")
        }
        .disabled(vocabularyIdentifiers.isEmpty == false)
    
        Divider()
    
        Button {
            guard let firstFetchedVocabulary: Vocabulary = context.fetch(by: vocabularyIdentifiers).first else { return }
            openEditVocabularyView(for: firstFetchedVocabulary)
        } label: {
            Text("Edit")
        }
        .disabled(vocabularyIdentifiers.count != 1)
        
        Divider()
        
        Button {
            context.checkToLearn(of: context.fetch(by: vocabularyIdentifiers))
        } label: {
            Text("To learn")
        }
        .disabled(vocabularyIdentifiers.isEmpty == true)
    
        Button {
            context.uncheckToLearn(of: context.fetch(by: vocabularyIdentifiers))
        } label: {
            Text("Not to learn")
        }
        .disabled(vocabularyIdentifiers.isEmpty == true)
        
        Divider()
        
        Button {
            let fetchedSelectedVocabularies: Array<Vocabulary> = context.fetch(by: vocabularyIdentifiers)
            context.resetLearningStates(of: fetchedSelectedVocabularies)
        } label: {
            if vocabularyIdentifiers.count == 1 {
                Text("Reset")
            }else {
                Text("Reset selected")
            }
        }
        .disabled(vocabularyIdentifiers.isEmpty == true)
        
        Button {
            deleteSelectedVocabularies(vocabularyIdentifiers: vocabularyIdentifiers)
        } label: {
            if vocabularyIdentifiers.count == 1 {
                Text("Delete")
            }else {
                Text("Delete selected")
            }
        }
        .disabled(vocabularyIdentifiers.isEmpty == true)
    }
    
    @ToolbarContentBuilder 
    var toolbarButtons: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Button {
                showLearningSheet()
            } label: {
                Image(.wordlistPlay)
            }
        }
        
        ToolbarItemGroup(placement: .primaryAction) {
            Spacer()
            
            Button {
                selectedList.addNewVocabulary()
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}



//MARK: - Preview
#Preview {
    DetailView(selectedList: VocabularyList("Preview List"), learningList: .constant(nil))
}

