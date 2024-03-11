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
            Label("All vocabularies", systemImage: "tray.full")
                .badge(fetchVocabulariesCount(of: nil), prominece: .decreased)
                .tag(ListSelectingValue.all)
            
            Section("Lists") {
                ForEach(lists) { list in
                    VocabularyListRow(list: list)
                        .badge(fetchVocabulariesCount(of: list), prominece: .decreased)
                        .tag(ListSelectingValue.list(list: list))
                }
            }
//            SidebarListsSection(lists: lists)
        }
        .contextMenu(forSelectionType: ListSelectingValue.self) { values in
            SidebarContextMenu(values: values, selectedListValue: $selectedList)
        }
        .focusedSceneValue(\.selectedList, $selectedList)
    }
}



//Unused
// - Because the VocabularyListRow needs to be updated when the user adds a new vocabulary.
struct SidebarListsSection: View {
    let lists: Array<VocabularyList>
    
    var body: some View {
        let _ = Self._printChanges()
        Section("Lists") {
            ForEach(lists) { list in
                NavigationLink(value: ListSelectingValue.list(list: list)) {
                    VocabularyListRow(list: list)
                }
            }
        }
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
        
        Button("Learn list") {
            
        }
        .disabled(values.isEmpty)
        
        Divider()
        
        Button("Sort list by") {
        
        }
        .disabled(values.isEmpty)
        
        Divider()
        
        ResetListButton(list: firstList)
            .disabled(values.isEmpty || values.contains(.all) == true)
        
        DeleteListButton(list: firstList, selectedList: $selectedListValue)
            .disabled(values.isEmpty || values.contains(.all) == true)
    }
}
