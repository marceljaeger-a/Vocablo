//
//  VocabularyListViewGeneric.swift
//  Vocablo
//
//  Created by Marcel Jäger on 19.01.24.
//

import Foundation
import SwiftUI
import SwiftData

struct VocabularyListDetailView: View {
    
    //MARK: - Properties
    
    let selectedList: VocabularyList?
    @Binding var learningList: VocabularyList?
    let isDuplicatesPopoverButtonAvailable: Bool
    let isListLabelAvailable: Bool
    
    @Environment(\.actionReactingService) private var actionPublisherService
    @Environment(\.selectionContext) private var  selectionContext: SelectionContext
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Environment(\.sheetContext) private var sheetContext: SheetContext
    
    @Query private var allVocabularies: Array<Vocabulary>
    @Query var filteredAndSortedVocabulariesOfSelectedList: Array<Vocabulary>
    
    @FocusState private var textFieldFocus: VocabularyTextFieldFocusState?
    
    //MARK: - Initialiser
    
    ///Set the Query depend if you give a selectedList or not.
    ///- You give: The view shows only vocabularies of the list sorted by its sorting.
    ///- You don't give: The view shows all vocabularies sorted by baseWord.
    init(of selectedList: VocabularyList?, learningList: Binding<VocabularyList?>, isDuplicatesPopoverButtonAvailable: Bool, isListLabelAvailable: Bool) {
        self.selectedList = selectedList
        self._learningList = learningList
        self.isDuplicatesPopoverButtonAvailable = isDuplicatesPopoverButtonAvailable
        self.isListLabelAvailable = isListLabelAvailable
        
        if let selectedList {
            let filteringListIdentifier = selectedList.persistentModelID
            let vocabulariesFilter = #Predicate<Vocabulary> { vocabulary in
                vocabulary.list?.persistentModelID == filteringListIdentifier
            }
            let vocabulariesFetchDescriptor = FetchDescriptor<Vocabulary>(predicate: vocabulariesFilter, sortBy: [selectedList.sorting.sortDescriptor])
            
            _filteredAndSortedVocabulariesOfSelectedList = Query(vocabulariesFetchDescriptor)
        } else {
            _filteredAndSortedVocabulariesOfSelectedList = Query(sort: \Vocabulary.baseWord)
        }
    }
    
    //MARK: - Methodes
    
    private func focusNewVocabulary(_ vocabulary: Vocabulary) {
        textFieldFocus = .word(vocabulary.id)
    }
    
    private func openEditVocabularyView(firstOf vocabularyIdentifiers: Set<PersistentIdentifier>) {
        guard let firstFetchedVocabulary: Vocabulary = modelContext.fetch(by: vocabularyIdentifiers).first else { return }
        sheetContext.editingVocabulary = firstFetchedVocabulary
    }
    
    private func showLearningSheet() {
        if let selectedList {
            self.learningList = selectedList
        }
    }
    
    private func deleteSelectedVocabularies(vocabularyIdentifiers: Set<PersistentIdentifier>) {
        _ = selectionContext.unselectVocabularies(vocabularyIdentifiers)
        modelContext.deleteVocabularies(allVocabularies[byIdentifiers: vocabularyIdentifiers])
    }
    
    private func addNewVocabulary() {
        let newVocabulary = Vocabulary(baseWord: "", translationWord: "", wordGroup: .noun)
        
        if let selectedList {
            selectedList.addVocabulary(newVocabulary)
        }else {
            modelContext.insert(newVocabulary)
        }
        
        try? modelContext.save()
        
        actionPublisherService.send(action: \.addingVocabulary, input: newVocabulary)
    }
    
    //MARK: - Body
    
    var body: some View {
        List(selection: selectionContext.bindable.selectedVocabularyIdentifiers) {
            ForEach(filteredAndSortedVocabulariesOfSelectedList, id: \.id) { vocabulary in
                VocabularyItem(vocabulary: vocabulary, textFieldFocus: $textFieldFocus, isDuplicateRecognitionLabelAvailable: isDuplicatesPopoverButtonAvailable, isListLabelAvailable: isListLabelAvailable)
                    .onSubmit {
                        addNewVocabulary()
                    }
            }
            .onDelete { indexSet in //Swipe & Delete menu command(not the keypress), when a vocabulary is selected.
                deleteSelectedVocabularies(vocabularyIdentifiers: filteredAndSortedVocabulariesOfSelectedList[indexSet].identifiers)
            }
        }
        .listStyle(.inset)
        .contextMenu(forSelectionType: Vocabulary.ID.self) { vocabularyIDs in
            contextMenuButtons(vocabularyIdentifiers: vocabularyIDs)
        } primaryAction: { vocabularyIdentifiers in
            openEditVocabularyView(firstOf: vocabularyIdentifiers)
        }
        .toolbar {
            toolbarButtons
        }
        .sheet(item: sheetContext.bindable.editingVocabulary) { vocabulary in
            EditVocabularyView(editingVocabulary: vocabulary)
        }
        .onAction(\.addingVocabulary) { newVocabulary in
            focusNewVocabulary(newVocabulary)
        }
    }
}



//MARK: - Subviews

extension VocabularyListDetailView {
    @ViewBuilder
    func contextMenuButtons(vocabularyIdentifiers: Set<PersistentIdentifier>) -> some View {
        Button {
            addNewVocabulary()
        } label: {
            Text("New vocabulary")
        }
        .disabled(vocabularyIdentifiers.isEmpty == false)
    
        Divider()
    
        Button {
            openEditVocabularyView(firstOf: vocabularyIdentifiers)
        } label: {
            Text("Edit")
        }
        .disabled(vocabularyIdentifiers.count != 1)
        
        Divider()
        
        Button {
            modelContext.checkToLearn(of: modelContext.fetch(by: vocabularyIdentifiers))
        } label: {
            Text("To learn")
        }
        .disabled(vocabularyIdentifiers.isEmpty == true)
    
        Button {
            modelContext.uncheckToLearn(of: modelContext.fetch(by: vocabularyIdentifiers))
        } label: {
            Text("Not to learn")
        }
        .disabled(vocabularyIdentifiers.isEmpty == true)
        
        Divider()
        
        Button {
            let fetchedSelectedVocabularies: Array<Vocabulary> = modelContext.fetch(by: vocabularyIdentifiers)
            modelContext.resetLearningStates(of: fetchedSelectedVocabularies)
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
                addNewVocabulary()
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}
