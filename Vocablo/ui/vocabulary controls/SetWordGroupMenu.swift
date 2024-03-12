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
    
    //MARK: - Dependencies
    
    let title: String
    let vocabularies: Set<Vocabulary>
    
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Methods
    
    private func perform(wordGoup: WordGroup) {
        vocabularies.forEach { element in
            element.wordGroup = wordGoup
        }
    }

    //MARK: - Body
    
    var body: some View {
        Menu(title) {
            ForEach(WordGroup.allCases, id: \.rawValue) { wordGoup in
                Button {
                    perform(wordGoup: wordGoup)
                } label: {
                    Label(wordGoup.rawValue, systemImage: "check")
                        .labelStyle(.titleOnly)
                }
            }
        }
    }
}
