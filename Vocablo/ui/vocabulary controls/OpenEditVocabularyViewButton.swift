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
    
    let vocabulary: Vocabulary?
    var label: () -> LabelContent
    
    @Environment(\.modelContext) var modelContext
    @Environment(PresentationModel.self) var presentationModel
    
    //MARK: - Initialiser
    
    init(
        open vocabulary: Vocabulary?,
        label: @escaping () -> LabelContent = { Text("Edit") }
    ) {
        self.vocabulary = vocabulary
        self.label = label
    }
    
    //MARK: - Methods
    
    private func perform() {
        presentationModel.showVocabularyDetailSheet(edit: vocabulary)
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
