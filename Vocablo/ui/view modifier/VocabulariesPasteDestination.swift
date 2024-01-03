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
    func vocabulariesPasteDestination(into list: VocabularyList?) -> some View {
        self.pasteDestination(for: Vocabulary.VocabularyTransfer.self) { vocabularyTransfers in
            if let list {
                for vocabularyTransfer in vocabularyTransfers{
                    list.addVocabulary(Vocabulary(from: vocabularyTransfer))
                }
            }
        }
    }
}
