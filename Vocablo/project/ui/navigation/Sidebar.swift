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
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \VocabularyList.created, order: .forward) private var  lists: Array<VocabularyList>
    
    //MARK: - Methods
    
    
    
    //MARK: - Body
    
    var body: some View {
        let _ = Self._printChanges()
        List(selection: $selectedList){
            NavigationLink(value: ListSelectingValue.all) {
                Label("All vocabularies", systemImage: "tray.full")
            }
                
            Section("Lists") {
                ForEach(lists) { list in
                    NavigationLink(value: ListSelectingValue.list(list: list)) {
                        VocabularyListRow(list: list)
                    }
                }
            }
        }
        .contextMenu(forSelectionType: ListSelectingValue.self) { values in
            SidebarContextMenu(values: values, selectedListValue: $selectedList)
        }
        .focusedSceneValue(\.selectedList, $selectedList)
    }
}



struct SidebarContextMenu: View {
    let values: Set<ListSelectingValue>
    @Binding var selectedListValue: ListSelectingValue
    
    @Environment(\.modelContext) var modelContext: ModelContext
    
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
