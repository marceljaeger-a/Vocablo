//
//  DeleteVocabulariesButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct DeleteVocabulariesButton<LabelContent: View>: View {
    
    //MARK: - Dependencies
    
    let vocabularies: Set<Vocabulary>
    @Binding var selectedVocabularies: Set<Vocabulary>
    var label: () -> LabelContent
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Initialiser
    
    init(
        vocabularies: Set<Vocabulary>,
        selectedVocabularies: Binding<Set<Vocabulary>>,
        label: @escaping () -> LabelContent = { Label("Delete", systemImage: "trash") }
    ) {
        self.vocabularies = vocabularies
        self._selectedVocabularies = selectedVocabularies
        self.label = label
    }
    
    //MARK: - Methods
    
    private func perform() {
        modelContext.delete(models: Array(vocabularies))
        
        _ = selectedVocabularies.remove(members: vocabularies)
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
