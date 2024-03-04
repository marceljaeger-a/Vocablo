//
//  ManipulateToLearnButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct SetVocabularyToLearnButton: View {
    
    //MARK: - Dependencies
    
    let vocabularyIdentifiers: Set<PersistentIdentifier>
    let newValue: Bool
    let title: String
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Initialiser
    
    init(_ vocabularyIdentifiers: Set<PersistentIdentifier>, to newValue: Bool, title: String) {
        self.vocabularyIdentifiers = vocabularyIdentifiers
        self.newValue = newValue
        self.title = title
    }
    
    //MARK: - Methods
    
    private func manipulateToLearnButton() {
        modelContext.fetchVocabularies(.byIdentifiers(vocabularyIdentifiers)).forEach { item in
            item.isToLearn = newValue
        }
    }
    
    //MARK: - Body
    
    var body: some View {
        Button {
            manipulateToLearnButton()
        } label: {
            Text(title)
        }
    }
}
