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
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.isSearching) private var isSearching
    @Environment(\.searchingText) private var  searchingText
    
    //MARK: - Methods

    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        if isSearching {
            SearchingVocabularyListView(searchingText: searchingText)
                .navigationTitle("Searching results")
        }else {
            if let selectedListModel = selectedList.list {
                ListVocabularyListView(list: selectedListModel)
            }else if selectedList == .all {
                AllVocabularyListView()
            }else {
                ContentUnavailableView("List is not available.", systemImage: "questionmark", description: nil)
            }
        }
    }
}





