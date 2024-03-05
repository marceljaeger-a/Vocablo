//
//  DeleteListButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 04.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct DeleteListButton: View {
    
    //MARK: - Dependencies
    
    let list: VocabularyList?
    @Environment(\.modelContext) var modelContext
    @FocusedBinding(\.selectedList) var selectedList
    
    //MARK: - Methods
    
    
    
    //MARK: - Body
    
    var body: some View {
        Button {
            guard let list else { return }
            modelContext.delete(models: [list])
            
            switch selectedList {
            case .all:
                break
            case .model(id: let id):
                if id == list.id {
                    selectedList = .all
                }
            case .none:
                break
            }
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
}
