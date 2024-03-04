//
//  ResetVocabulariesButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct ResetVocabulariesButton: View {
    
    //MARK: - Dependencies
    
    let title: String 
    let vocabularyIdentifiers: Set<PersistentIdentifier>
    
    @Environment(\.modelContext) var modelContext

    //MARK: - Initialiser
    
    init(title: String = "Reset", _ vocabularyIdentifiers: Set<PersistentIdentifier>) {
        self.title = title
        self.vocabularyIdentifiers = vocabularyIdentifiers
    }
    
    //MARK: - Methods
    
    private func resetVocabularies() {
        modelContext.fetchVocabularies(.byIdentifiers(vocabularyIdentifiers)).forEach { vocabulary in
            vocabulary.resetLearningsStates()
        }
    }
    
    //MARK: - Body
    
    var body: some View {
        Button {
            resetVocabularies()
        } label: {
            Text(title)
        }
    }
}
