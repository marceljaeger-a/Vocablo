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
    @State private var selectedVocabularies: Set<Vocabulary> = []
    @State private var editedVocabulary: Vocabulary? = nil
    @FocusState var focusedVocabularyTextField: FocusedVocabularyTextField?
    @Environment(\.modelContext) var modelContext
    
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
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
       
        List(selection: $selectedVocabularies) {
            ForEach(filteredVocabularies, id: \.self) { vocabulary in
                VocabularyRow(vocabulary: vocabulary, focusedTextField: $focusedVocabularyTextField, list: list)
            }
        }
        .listStyle(.inset)
        .contextMenu(forSelectionType: Vocabulary.self) { vocabularies in
            VocabularyListViewContextMenu(vocabularies: vocabularies, selectedList: list, selectedVocabularies: $selectedVocabularies, editedVocabulary: $editedVocabulary)
        } primaryAction: { vocabularies in
            if vocabularies.count == 1 {
                editedVocabulary = vocabularies.first
            }
        }
        .toolbar {
            VocabularyListViewToolbar(selectedList: list)
        }
        .sheet(item: $editedVocabulary) { vocabulary in
            EditVocabularyView(vocabulary: vocabulary)
        }
        .focusedValue(\.selectedVocabularies, $selectedVocabularies)
    }
}



struct VocabularyListViewContextMenu: View {
    let vocabularies: Set<Vocabulary>
    let selectedList: VocabularyList?
    @Binding var selectedVocabularies: Set<Vocabulary>
    @Binding var editedVocabulary: Vocabulary?
    @Environment(\.isSearching) var isSearching
    
    var body: some View {
        AddNewVocabularyButton(into: selectedList)
            .disabled(
                vocabularies.isEmpty == false &&
                isSearching == false
            )
        
        Divider()
        
        OpenEditVocabularyViewButton(sheetValue: $editedVocabulary, open: vocabularies.first)
            .disabled(vocabularies.count != 1)
        
        SetVocabulariesToLearnButton(vocabularies, to: true) {
            Text("Set to learn")
        }
        .disabled(vocabularies.isEmpty)
        
        SetVocabulariesToLearnButton(vocabularies, to: false) {
            Text("Set not to learn")
        }
        .disabled(vocabularies.isEmpty)
        
        Divider()
        
        ResetVocabulariesButton(vocabularies: vocabularies)
            .disabled(vocabularies.isEmpty)
        
        DeleteVocabulariesButton(vocabularies: vocabularies, selectedVocabularies: $selectedVocabularies)
            .disabled(vocabularies.isEmpty)
    }
}

struct VocabularyListViewToolbar: ToolbarContent {
    let selectedList: VocabularyList?
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
            AddNewVocabularyButton(into: selectedList)
                .disabled(isSearching)
        }
    }
}
