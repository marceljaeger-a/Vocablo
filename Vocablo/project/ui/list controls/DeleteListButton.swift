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
    
    //MARK: - Methods
    
    
    
    //MARK: - Body
    
    var body: some View {
        Button {
            #warning("The selectingValue should be changed!")
            guard let list else { return }
            modelContext.delete(models: [list])
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
}
