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
    
    var registeredSelectedListModel: VocabularyList? {
        switch selectedList {
        case .all:
            return nil
        case .model(let id):
            return modelContext.registeredModel(for: id)
        }
    }
    
    //MARK: - Methods
    
    private func getListQuery(listIdentifier: PersistentIdentifier) -> Query<Vocabulary, Array<Vocabulary>> {
        let listIdentifier = listIdentifier
        let predicate: Predicate<Vocabulary> = #Predicate { vocabulary in
            vocabulary.list?.persistentModelID == listIdentifier
        }
        let fetchDescriptor: FetchDescriptor<Vocabulary> = FetchDescriptor(predicate: predicate)
        
        return Query(fetchDescriptor)
    }
    
    private let searchingFilter: (Vocabulary, String) -> Bool  = {
        vocabulary, searchingText in
            vocabulary.baseWord.caseInsensitiveContains(searchingText) ||
            vocabulary.translationWord.caseInsensitiveContains(searchingText) ||
            vocabulary.baseSentence.caseInsensitiveContains(searchingText) ||
            vocabulary.translationSentence.caseInsensitiveContains(searchingText)
    }
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        if isSearching {
            VocabularyListView(searchingText: searchingText, searchingFilter: searchingFilter)
                .navigationTitle("Searching results")
        }else {
            if let registeredSelectedListModel {
                VocabularyListView(list: registeredSelectedListModel)
            }else {
                VocabularyListView()
            }
        }
    }
}





