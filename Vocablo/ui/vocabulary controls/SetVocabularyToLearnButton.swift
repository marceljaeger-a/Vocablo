//
//  ManipulateToLearnButton.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct SetVocabulariesToLearnButton<LabelContent: View>: View {
    
    //MARK: - Dependencies
    
    let vocabularies: Set<Vocabulary>
    let newValue: Bool
    let label: () -> LabelContent
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Initialiser
    
    init(
        _ vocabularies: Set<Vocabulary>,
        to newValue: Bool,
        label: @escaping () -> LabelContent
    ) {
        self.vocabularies = vocabularies
        self.newValue = newValue
        self.label = label
    }
    
    //MARK: - Methods
    
    private func perform() {
        vocabularies.forEach { item in
            item.isToLearn = newValue
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
