//
//  VocabularyListView.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.02.24.
//

import Foundation
import SwiftUI
import SwiftData

//enum FocusedRow: Hashable {
//    case id(PersistentIdentifier)
//}

struct VocabularyListView: View {
    
    //MARK: - Dependencies
    
    let selectedListValue: ListSelectingValue
    @Binding var selectedVocabularies: Set<Vocabulary>
    
    @AppStorage(AppStorageKeys.vocabularySortingKey) var vocabularySortingKey: VocabularySortingKey = .createdDate
    @AppStorage(AppStorageKeys.vocabularySortingOrder) var vocabularySortingOrder: SortingOrder = .ascending
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.isSearching) var isSearching
    @Environment(\.searchingText) var searchingText
    @Environment(\.onAddingVocabularySubject) var onAddingVocabularySubject
    
    private var currentQuery: Query<Vocabulary, Array<Vocabulary>> {
        if isSearching {
            let predicate: Predicate<Vocabulary> = #Predicate { vocabulary in
                vocabulary.baseWord.localizedStandardContains(searchingText) ||
                vocabulary.translationWord.localizedStandardContains(searchingText) ||
                vocabulary.baseSentence.localizedStandardContains(searchingText) ||
                vocabulary.translationSentence.localizedStandardContains(searchingText)
            }
            
            return Query(filter: predicate)
        }else {
            switch selectedListValue {
            case .all:
                return Query(sort: [SortDescriptor<Vocabulary>.vocabularySortDescriptor(by: vocabularySortingKey, order: vocabularySortingOrder)])
            case .list(let list):
                return Query(.vocabularies(of: list, sortBy: [SortDescriptor<Vocabulary>.vocabularySortDescriptor(by: vocabularySortingKey, order: vocabularySortingOrder)]))
            }
        }
    }
    
    //MARK: - Methods
    
    private func isSelected(_ vocabulary: Vocabulary) -> Bool {
        selectedVocabularies.contains(vocabulary) && selectedVocabularies.count == 1
    }
    
    private func onSubmitAction() {
        guard isSearching == false else { return }
        let newVocabulary = Vocabulary.newVocabulary
        switch selectedListValue {
        case .all:
            modelContext.insert(newVocabulary)
        case .list(let list):
            list.append(vocabulary: newVocabulary)
        }
        try? modelContext.save()
        
        onAddingVocabularySubject.send(newVocabulary)
    }
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        ScrollViewReader { proxy in
            List(selection: $selectedVocabularies) {
                VocabularyQueryView(currentQuery){ vocabulary in
                    VocabularyRow(vocabulary: vocabulary, isSelected: isSelected(vocabulary))
                        .onSubmit {
                            onSubmitAction()
                        }
                }
            }
            .listStyle(.inset)
            .onReceive(onAddingVocabularySubject.delay(for: 0.1, scheduler: DispatchQueue.main), performIfControlActiveStateIs: .key, perform: { output in
                proxy.scrollTo(output)
                selectedVocabularies = [output]
            })
        }
    }
}

