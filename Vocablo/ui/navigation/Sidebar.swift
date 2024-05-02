//
//  Sidebar.swift
//  Vocablo
//
//  Created by Marcel Jäger on 28.02.24.
//

import Foundation
import SwiftUI
import SwiftData

struct Sidebar: View {
    
    //MARK: - Dependencies
    
    @Binding var selectedList: ListSelectingValue
    
    @Query(sort: \VocabularyList.created, order: .forward) private var  lists: Array<VocabularyList>
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: Initialiser
    
    init(selectedList: Binding<ListSelectingValue>, listSortingKey: ListSortingKey, listSortingOrder: SortingOrder) {
        self._selectedList = selectedList
        
        self._lists = Query(sort: [SortDescriptor<VocabularyList>.listSortDescriptor(by: listSortingKey, order: listSortingOrder)])
    }
    
    //MARK: - Body
    
    func fetchVocabulariesCount(of list: VocabularyList?) -> Int {
        do {
            if let list {
                return try modelContext.fetchCount(.vocabularies(of: list))
            }else {
                return try modelContext.fetchCount(.vocabularies())
            }
        } catch {
            return 0
        }
    }
    
    var body: some View {
        let _ = Self._printChanges()
        List(selection: $selectedList){
            #warning("LearningVocabulariesCountBadgeModifier causes less performance because of the Query!")
            Label("All vocabularies", systemImage: "tray.full")
                .modifier(LearningVocabulariesCountBadgeModifier(listValue: .all))
                .badge(fetchVocabulariesCount(of: nil))
                .badgeProminence(.decreased)
                .tag(ListSelectingValue.all)
            
            Section("Lists") {
                ForEach(lists) { list in
                    #warning("LearningVocabulariesCountBadgeModifier causes less performance because of the Query!")
                    VocabularyListRow(list: list)
                        .modifier(LearningVocabulariesCountBadgeModifier(listValue: .list(list: list)))
                        .badge(fetchVocabulariesCount(of: list))
                        .badgeProminence(.decreased)
                        .tag(ListSelectingValue.list(list: list))
                }
            }
//            SidebarListsSection(lists: lists)
        }
        .contextMenu(forSelectionType: ListSelectingValue.self) { values in
            SidebarContextMenu(values: values, selectedListValue: $selectedList)
        }
        .overlay(alignment: .bottomLeading) {
            AddNewListButton {
                Label("New list", systemImage: "plus")
            }
            .buttonStyle(.plain)
            .padding()
        }
        .focusedSceneValue(\.selectedList, $selectedList)
    }
}



struct SidebarContextMenu: View {
    let values: Set<ListSelectingValue>
    @Binding var selectedListValue: ListSelectingValue
    
    var firstList: VocabularyList? {
        return values.first?.list
    }
    
    var body: some View {
        AddNewListButton()
            .disabled(values.isEmpty == false)
        
        LearnVocabulariesButton(selectedListValue: values.first)
        
        Divider()
        
        ListSortingPicker()
        VocabularySortingPicker()
        
        Divider()
        
        ResetListButton(list: firstList)
            .disabled(values.isEmpty || values.contains(.all) == true)
        
        DeleteListButton(list: firstList, selectedList: $selectedListValue)
            .disabled(values.isEmpty || values.contains(.all) == true)
    }
}
