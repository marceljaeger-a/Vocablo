//
//  DeleteListButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 04.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct DeleteListButton<LabelContent: View>: View {
    
    //MARK: - Dependencies
    
    let list: VocabularyList?
    @Binding var selectedList: ListSelectingValue
    var label: () -> LabelContent
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Initialiser
    
    init(
        list: VocabularyList?,
        selectedList: Binding<ListSelectingValue>,
        label: @escaping () -> LabelContent = { Label("Delete", systemImage: "trash") }
    ) {
        self.list = list
        self._selectedList = selectedList 
        self.label = label
    }
    
    //MARK: - Methods
    
    private func perform() {
        guard let list else { return }
        
        modelContext.delete(models: [list])
        
        if let selectedListModel = selectedList.list {
            if list.id == selectedListModel.id {
                selectedList = .all
            }
        }
    }
    
    //MARK: - Body
    
    var body: some View {
        Button {
            perform()
        } label: {
            label()
        }
    }
}
