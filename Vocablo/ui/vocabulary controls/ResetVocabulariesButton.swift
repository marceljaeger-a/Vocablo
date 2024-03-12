//
//  ResetVocabulariesButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct ResetVocabulariesButton<LabelContent: View>: View {
    
    //MARK: - Dependencies
    
    let vocabularies: Set<Vocabulary>
    var label: () -> LabelContent
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Initialiser
    
    init(
        vocabularies: Set<Vocabulary>,
        label: @escaping () -> LabelContent = { Text("Reset") }
    ) {
        self.vocabularies = vocabularies
        self.label = label
    }
    
    //MARK: - Methods
    
    private func perform() {
        vocabularies.forEach { vocabulary in
            vocabulary.resetLearningsStates()
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
