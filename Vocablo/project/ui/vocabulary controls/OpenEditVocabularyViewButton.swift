//
//  OpenEditVocabularyViewButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 05.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct OpenEditVocabularyViewButton<LabelContent: View>: View {
    
    //MARK: - Dependencies
    
    @Binding var editedVocabulary: Vocabulary?
    let vocabulary: Vocabulary?
    var label: () -> LabelContent
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Initialiser
    
    init(
        sheetValue editedVocabulary: Binding<Vocabulary?>,
        open vocabulary: Vocabulary?,
        label: @escaping () -> LabelContent = { Text("Edit") }
    ) {
        self._editedVocabulary = editedVocabulary
        self.vocabulary = vocabulary
        self.label = label
    }
    
    //MARK: - Methods
    
    private func perform() {
        editedVocabulary = vocabulary
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
