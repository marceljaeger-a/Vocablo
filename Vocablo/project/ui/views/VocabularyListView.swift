//
//  VocabularyListView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.02.24.
//

import Foundation
import SwiftUI
import SwiftData

enum FocusedVocabularyTextField: Hashable {
    case baseWord(vocabularyIdentifier: PersistentIdentifier)
    case translationWord(vocabularyIdentifier: PersistentIdentifier)
    case baseSentence(vocabularyIdentifier: PersistentIdentifier)
    case translationSentence(vocabularyIdentifier: PersistentIdentifier)
}

struct VocabularyListView: View {
    
    //MARK: - Dependencies
    
    var searchingFilter: Optional<(Vocabulary, String) -> Bool> = nil
    var searchingText: Optional<String> = nil
    
    var list: VocabularyList? = nil
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.isSearching) var isSearching
    
    @Query private var vocabularies: Array<Vocabulary>
    private var filteredVocabularies: Array<Vocabulary> {
        if let searchingFilter, let searchingText{
            return vocabularies.filter {
                searchingFilter($0, searchingText)
            }
        }else {
            return vocabularies
        }
    }
    @State private var selectedVocabularies: Set<PersistentIdentifier> = []
    @State private var editedVocabulary: Vocabulary? = nil
    
    @FocusState var focusedVocabularyTextField: FocusedVocabularyTextField?
    
    //MARK: - Initialiser
    
    //Normal variant
    init(
        query: Query<Vocabulary, Array<Vocabulary>> = .init(.vocabularies())
    ) {
        self._vocabularies = query
    }
    
    //List variant
    init(
        list: VocabularyList,
        sortVocabulariesBy sortDescriptor: Array<SortDescriptor<Vocabulary>> = []
    ) {
        self._vocabularies = Query(.vocabularies(of: list, sortBy: sortDescriptor))
        self.list = list
    }
    
    //Searching variant
    init(
        query: Query<Vocabulary, Array<Vocabulary>> = .init(.vocabularies()),
        searchingText: String
    ) {
        self.init(query: query)
        
        self.searchingText = searchingText
        self.searchingFilter = {
            vocabulary, searchingText in
                vocabulary.baseWord.caseInsensitiveContains(searchingText) ||
                vocabulary.translationWord.caseInsensitiveContains(searchingText) ||
                vocabulary.baseSentence.caseInsensitiveContains(searchingText) ||
                vocabulary.translationSentence.caseInsensitiveContains(searchingText)
        }
    }
    
    //MARK: - Methods

    private func onSumbmitAction() {
        guard isSearching == false else { return }
        
        let newVocabulary = Vocabulary.newVocabulary
        if let list {
            list.append(vocabulary: newVocabulary)
        }else {
            modelContext.insert(newVocabulary)
        }
        
        try? modelContext.save()
    }
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
       
        List(selection: $selectedVocabularies) {
            ForEach(filteredVocabularies, id: \.id) { vocabulary in
                VocabularyRow(vocabulary: vocabulary, focusedTextField: $focusedVocabularyTextField)
                    .onSubmit(onSumbmitAction)
            }
        }
        .listStyle(.inset)
        .contextMenu(forSelectionType: PersistentIdentifier.self) { identifiers in
            VocabularyListViewContextMenu(identifiers: identifiers, list: list, editedVocabulary: $editedVocabulary)
        } primaryAction: { identifiers in
            OpenEditVocabularyViewButton.openEditVocabularyView(editedVocabulary: &editedVocabulary, identifiers: identifiers, modelContext: modelContext)
        }
        .toolbar {
            VocabularyListViewToolbar(list: list)
        }
        .sheet(item: $editedVocabulary) { vocabulary in
            EditVocabularyView(vocabulary: vocabulary)
        }
        .focusedValue(\.selectedVocabularies, $selectedVocabularies)
    }
}



struct VocabularyListViewContextMenu: View {
    let identifiers: Set<PersistentIdentifier>
    let list: VocabularyList?
    @Binding var editedVocabulary: Vocabulary?
    
    var body: some View {
        NewVocabularyButton(list: list)
            .disabled(identifiers.isEmpty == false)
        
        Divider()
        
        OpenEditVocabularyViewButton(editedVocabulary: $editedVocabulary, identifiers: identifiers)
            .disabled(identifiers.count != 1)
        
        SetVocabularyToLearnButton(identifiers, to: true, title: "Set to learn")
            .disabled(identifiers.isEmpty)
        
        SetVocabularyToLearnButton(identifiers, to: false, title: "Set not to learn")
            .disabled(identifiers.isEmpty)
        
        Divider()
        
        ResetVocabulariesButton(identifiers)
            .disabled(identifiers.isEmpty)
        
        DeleteVocabulariesButton(identifiers)
            .disabled(identifiers.isEmpty)
    }
}

struct VocabularyListViewToolbar: ToolbarContent {
    let list: VocabularyList?
    @Environment(\.isSearching) var isSearching
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Button {
                
            } label: {
                Image(.wordlistPlay)
            }
            .disabled(isSearching)
        }
        
        ToolbarItem(placement: .primaryAction) {
            NewVocabularyButton(list: list)
                .disabled(isSearching)
        }
    }
}
