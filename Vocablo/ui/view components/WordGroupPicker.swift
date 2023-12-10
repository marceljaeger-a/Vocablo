//
//  WordGroupPicker.swift
//  Vocablo
//
//  Created by Marcel Jäger on 26.11.23.
//

import Foundation
import SwiftUI

struct WordGroupPicker: View {
    @Bindable var vocabulary: Vocabulary
    
    var body: some View {
        Menu(vocabulary.wordGroup.rawValue) {
            ForEach(WordGroup.allCases, id: \.rawValue) { wordGroup in
                Button {
                    selectWordGroup(wordGroup)
                } label: {
                    Text(wordGroup.rawValue)
                }
                .disabled(vocabulary.wordGroup == wordGroup)
            }
        }
        .menuStyle(BorderlessButtonMenuStyle())
    }
    
    private func selectWordGroup(_ wordGroup: WordGroup) {
        vocabulary.wordGroup = wordGroup
    }
}

struct CommandWordGroupPicker: View {
    let vocabularies: Array<Vocabulary>
    
    var body: some View {
        Menu("Word group") {
            ForEach(WordGroup.allCases, id: \.rawValue) { wordGroup in
                Button {
                    selectWordGroup(wordGroup)
                } label: {
                    Text(wordGroup.rawValue)
                }
            }
        }
        .menuStyle(BorderlessButtonMenuStyle())
    }
    
    private func selectWordGroup(_ wordGroup: WordGroup) {
        for vocabulary in vocabularies {
            guard vocabulary.wordGroup != wordGroup else { continue }
            vocabulary.wordGroup = wordGroup
        }
    }
}
