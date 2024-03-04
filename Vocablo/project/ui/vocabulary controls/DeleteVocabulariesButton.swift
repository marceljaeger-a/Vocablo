//
//  DeleteVocabulariesButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct DeleteVocabulariesButton: View {
    
    //MARK: - Dependencies
    
    let vocabularyIdentifiers: Set<PersistentIdentifier>
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Initialiser
    
    init(_ vocabularyIdentifiers: Set<PersistentIdentifier>) {
        self.vocabularyIdentifiers = vocabularyIdentifiers
    }
    
    //MARK: - Methods
    
    private func deleteVocabularies() {
        #warning("The deltedVocabularies need to be removed from the selected vocabularies set!")
        let fetchedVocabularies = modelContext.fetchVocabularies(.byIdentifiers(vocabularyIdentifiers))
        modelContext.delete(models: fetchedVocabularies)
    }
    
    //MARK: - Body
    
    var body: some View {
        Button {
            deleteVocabularies()
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
}
