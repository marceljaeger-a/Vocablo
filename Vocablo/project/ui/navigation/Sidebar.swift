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
            Label("All vocabularies", systemImage: "tray.full")
                .tag(ListSelectingValue.all)
                
            Section("Lists") {
                ForEach(lists) { list in
                    VocabularyListRow(list: list)
                        .tag(ListSelectingValue.model(id: list.id))
                }
            }
        }
        .contextMenu(forSelectionType: ListSelectingValue.self) { selectingValues in
            SidebarContextMenu(selectingValues: selectingValues)
        }
        .focusedSceneValue(\.selectedList, $selectedList)
    }
}



struct SidebarContextMenu: View {
    let selectingValues: Set<ListSelectingValue>
    
    @Environment(\.modelContext) var modelContext: ModelContext
    
    var registerdList: VocabularyList? {
        guard let listID = selectingValues.first?.modelIdentifier else { return nil }
        return modelContext.registeredModel(for: listID)
    }
    
    var body: some View {
        NewListButton()
            .disabled(selectingValues.isEmpty == false)
        
        Button("Learn list") {
            
        }
        .disabled(selectingValues.isEmpty)
        
        Divider()
        
        Button("Sort list by") {
        
        }
        .disabled(selectingValues.isEmpty)
        
        Divider()
        
        ResetListButton(list: registerdList)
            .disabled(selectingValues.isEmpty || selectingValues.contains(.all) == true)
        
        DeleteListButton(list: registerdList)
            .disabled(selectingValues.isEmpty || selectingValues.contains(.all) == true)
    }
}
