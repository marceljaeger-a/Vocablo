//
//  VocabulariesPasteDestination.swift
//  Vocablo
//
//  Created by Marcel Jäger on 07.12.23.
//

import Foundation
import SwiftUI
import SwiftData

extension View {
    func vocabulariesPasteDestination(into list: VocabularyList?, context: ModelContext) -> some View {
        self.pasteDestination(for: Vocabulary.VocabularyTransfer.self) { vocabularyTransfers in
            if let list {
                for vocabularyTransfer in vocabularyTransfers{
                    list.addVocabulary(Vocabulary(from: vocabularyTransfer))
                }
            }else {
                for vocabularyTransfer in vocabularyTransfers {
                    let pastedVocabulary = Vocabulary(from: vocabularyTransfer)
                    context.insert(pastedVocabulary)
                    try? context.save()
                }
            }
        }
    }
}
