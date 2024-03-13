//
//  Detail.swift
//  Vocablo
//
//  Created by Marcel Jäger on 29.02.24.
//

import Foundation
import SwiftUI
import SwiftData

struct Detail: View {
    
    //MARK: - Dependencies
    
    @Binding var selectedList: ListSelectingValue
    
    @Environment(\.isSearching) private var isSearching
    @Environment(\.searchingText) private var searchingText
    
    @AppStorage(AppStorageKeys.vocabularySortingKey) var vocabularySortingKey: VocabularySortingKey = .createdDate
    @AppStorage(AppStorageKeys.vocabularySortingOrder) var vocabularySortingOrder: SortingOrder = .ascending
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        if isSearching {
            SearchingVocabularyListView(searchingText: searchingText)
                .navigationTitle("Searching results")
        }else {
            if let selectedListModel = selectedList.list {
                ListVocabularyListView(list: selectedListModel, vocabularySortingKey: vocabularySortingKey, vocabularySortingOrder: vocabularySortingOrder)
                    .id(UUID())
            }else if selectedList == .all {
                AllVocabularyListView(vocabularySortingKey: vocabularySortingKey, vocabularySortingOrder: vocabularySortingOrder)
            }else {
                ContentUnavailableView("List is not available.", systemImage: "questionmark", description: nil)
            }
        }
    }
}





