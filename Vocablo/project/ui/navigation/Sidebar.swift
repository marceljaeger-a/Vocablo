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
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        List(selection: $selectedList){
            NavigationLink(value: ListSelectingValue.all) {
                Label("All vocabularies", systemImage: "tray.full")
            }
                
            SidebarListsSection(lists: lists)
        }
        .contextMenu(forSelectionType: ListSelectingValue.self) { values in
            SidebarContextMenu(values: values, selectedListValue: $selectedList)
        }
        .focusedSceneValue(\.selectedList, $selectedList)
    }
}


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
