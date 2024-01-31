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
    
    @Environment(\.actionReactingService) private var actionPublisherService
    @Environment(\.selections) private var  selections: SelectionContext
    @Environment(\.modelContext) private var context: ModelContext
    @Environment(\.sheetContext) private var sheetContext: SheetContext
    
    @Query private var allVocabularies: Array<Vocabulary>
    @Query var filteredAndSortedVocabulariesOfSelectedList: Array<Vocabulary>
    
    @FocusState private var textFieldFocus: VocabularyTextFieldFocusState?
    
    //MARK: - Initialiser
    
    ///Set the Query depend if you give a selectedList or not.
    ///- You give: The view shows only vocabularies of the list sorted by its sorting.
    ///- You don't give: The view shows all vocabularies sorted by baseWord.
    init(of selectedList: VocabularyList?, learningList: Binding<VocabularyList?>, isDuplicatesPopoverButtonAvailable: Bool) {
        self.selectedList = selectedList
        self._learningList = learningList
        self.isDuplicatesPopoverButtonAvailable = isDuplicatesPopoverButtonAvailable
        
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
        guard let firstFetchedVocabulary: Vocabulary = context.fetch(by: vocabularyIdentifiers).first else { return }
        sheetContext.editingVocabulary = firstFetchedVocabulary
    }
    
    private func showLearningSheet() {
        if let selectedList {
            self.learningList = selectedList
        }
    }
    
    private func deleteSelectedVocabularies(vocabularyIdentifiers: Set<PersistentIdentifier>) {
        _ = selections.unselectVocabularies(vocabularyIdentifiers)
        context.deleteVocabularies(allVocabularies[byIdentifiers: vocabularyIdentifiers])
    }
    
    private func addNewVocabulary() {
        let newVocabulary = Vocabulary(baseWord: "", translationWord: "", wordGroup: .noun)
        
        if let selectedList {
            selectedList.addVocabulary(newVocabulary)
        }else {
            context.insert(newVocabulary)
        }
        
        try? context.save()
        
        actionPublisherService.send(action: \.addingVocabulary, input: newVocabulary)
    }
    
    //MARK: - Body
    
    var body: some View {
        List(selection: selections.bindable.selectedVocabularyIdentifiers) {
            ForEach(filteredAndSortedVocabulariesOfSelectedList, id: \.id) { vocabulary in
                VocabularyItem(vocabulary: vocabulary, textFieldFocus: $textFieldFocus, isDuplicateRecognitionLabelAvailable: isDuplicatesPopoverButtonAvailable)
                    .onSubmit {
                        addNewVocabulary()
                    }
            }
            .onDelete { indexSet in //Swipe & Delete menu command(not the keypress), when a vocabulary is selected.
                deleteSelectedVocabularies(vocabularyIdentifiers: filteredAndSortedVocabulariesOfSelectedList[indexSet].identifiers)
            }
        }
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
                addNewVocabulary()
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}
