//
//  SetWordGroupMenu.swift
//  Vocablo
//
//  Created by Marcel Jäger on 04.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct SetWordGroupMenu: View {
    let title: String
    let vocabularies: Set<PersistentIdentifier>
    
    @Environment(\.modelContext) var modelContext
    
    init(title: String, of vocabularies: Set<PersistentIdentifier>) {
        self.title = title
        self.vocabularies = vocabularies
    }
    
    var body: some View {
        Menu(title) {
            ForEach(WordGroup.allCases, id: \.rawValue) { wordGoup in
                Button {
                    modelContext.fetchVocabularies(.byIdentifiers(vocabularies)).forEach { element in
                        element.wordGroup = wordGoup
                    }
                } label: {
                    Label(wordGoup.rawValue, systemImage: "check")
                        .labelStyle(.titleOnly)
                }
            }
        }
    }
}
