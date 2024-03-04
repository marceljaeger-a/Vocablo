//
//  VocabularyListView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.02.24.
//

import Foundation
import SwiftUI
import SwiftData

struct VocabularyListView: View {
    
    //MARK: - Dependencies
    
    var searchingFilter: Optional<(Vocabulary, String) -> Bool> = nil
    var searchingText: Optional<String> = nil
    
    var list: VocabularyList? = nil
    
    @Environment(\.modelContext) var modelContext
    
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
        searchingText: String ,
        searchingFilter: @escaping (Vocabulary, String) -> Bool
    ) {
        self.init(query: query)
        
        self.searchingText = searchingText
        self.searchingFilter = searchingFilter
    }
    
    //MARK: - Methods
    
    private func openEditVocabularyView(with identifiers: Set<PersistentIdentifier>) {
        guard identifiers.count == 1 else { return }
        guard let identifier = identifiers.first else { return }
        guard let registeredVocabulary: Vocabulary = modelContext.registeredModel(for: identifier) else { return }
        editedVocabulary = registeredVocabulary
    }
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        List(selection: $selectedVocabularies) {
            ForEach(filteredVocabularies, id: \.id) { vocabulary in
                VocabularyRow(vocabulary: vocabulary)
            }
        }
        .listStyle(.inset)
        .contextMenu(forSelectionType: PersistentIdentifier.self) { identifiers in
            VocabularyListViewContextMenu(identifiers: identifiers, list: list)
        } primaryAction: { identifiers in
            openEditVocabularyView(with: identifiers)
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
    
    var body: some View {
        NewVocabularyButton(list: list)
            .disabled(identifiers.isEmpty == false)
        
        Divider()
        
        Button("Edit") {
            
        }
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
