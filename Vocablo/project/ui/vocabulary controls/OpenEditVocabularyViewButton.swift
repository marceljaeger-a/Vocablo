//
//  OpenEditVocabularyViewButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 05.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct OpenEditVocabularyViewButton: View {
    
    //MARK: - Dependencies
    
    var title: String = "Edit"
    @Binding var editedVocabulary: Vocabulary?
    let identifiers: Set<PersistentIdentifier>
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Methods
    
    static func openEditVocabularyView(editedVocabulary: inout Vocabulary?, identifiers: Set<PersistentIdentifier>, modelContext: ModelContext) {
        guard identifiers.count == 1 else { return }
        guard let identifier = identifiers.first else { return }
        guard let registeredVocabulary: Vocabulary = modelContext.registeredModel(for: identifier) else { return }
        editedVocabulary = registeredVocabulary
    }
    
    //MARK: - Body
    
    var body: some View {
        Button(title) {
            Self.openEditVocabularyView(editedVocabulary: &editedVocabulary, identifiers: identifiers, modelContext: modelContext)
        }
    }
}
