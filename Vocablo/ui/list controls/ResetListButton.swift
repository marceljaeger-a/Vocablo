//
//  ResetListButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 04.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct ResetListButton<LabelContent: View>: View {
    
    //MARK: - Dependencies
    
    let list: VocabularyList?
    var label: () -> LabelContent
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Initialiser
    
    init(
        list: VocabularyList?,
        label: @escaping () -> LabelContent = { Text("Reset") }
    ) {
        self.list = list
        self.label = label
    }
    
    //MARK: - Methods
    
    private func perform() {
        guard let list else { return }
        let fetchedVocabulariesOfList = modelContext.fetchVocabularies(.vocabularies(of: list))
        fetchedVocabulariesOfList.forEach { vocabulary in
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
