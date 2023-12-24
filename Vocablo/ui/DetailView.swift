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
    @Binding var selectedVocabularyIdentifiers: Set<PersistentIdentifier>
    @Binding var learningList: VocabularyList?
    
    @Environment(\.modelContext) private var context: ModelContext
    @Query private var allVocabularies: Array<Vocabulary>
    @State private var editingVocabulary: Vocabulary?
    @FocusState private var textFieldFocus: VocabularyTextFieldFocusState?
    
    //MARK: - Methodes
    
    private func focusAndSelectNewVocabulary(_ vocabulary: Vocabulary) {
        textFieldFocus = nil //This helps for the "AttributeGraph" message!
        selectedVocabularyIdentifiers = []
        selectedVocabularyIdentifiers.insert(vocabulary.id) //This causes an "AttributeGraph" message!
        Task { //This helps for the nonfocsuing, when an other vocabulary is focued, while I add a new list.
            textFieldFocus = .word(vocabulary.id)
        }
    }
    
    private func openEditVocabularyView(for vocabulary: Vocabulary) {
        editingVocabulary = vocabulary
    }
    
    private func showLearningSheet() {
        self.learningList = selectedList
    }
    
    private func contextMenuPrimaryAction(vocabularyIDs: Set<PersistentIdentifier>) {
        if vocabularyIDs.count == 1 {
            guard let firstVocabulary: Vocabulary = context.fetch(by: vocabularyIDs).first else { return }
            openEditVocabularyView(for: firstVocabulary)
        }
    }
    
    //MARK: - Body
    
    var body: some View {
        VocabulariesListView(vocabularies: selectedList.sortedVocabularies, selection: $selectedVocabularyIdentifiers, textFieldFocus: $textFieldFocus, onSubmitAction: selectedList.addNewVocabulary)
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
            .onAddVocabulary(to: selectedList) { newVocabulary in
                focusAndSelectNewVocabulary(newVocabulary)
            }
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
            context.deleteVocabularies(context.fetch(by: vocabularyIdentifiers))
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
    DetailView( selectedList: VocabularyList("Preview List"), selectedVocabularyIdentifiers: .constant([]), learningList: .constant(nil))
}

