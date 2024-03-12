//
//  CopyableVocabulariesModifier.swift
//  Vocablo
//
//  Created by Marcel Jäger on 11.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct CopyableVocabuariesModifier: ViewModifier {
    @FocusedBinding(\.selectedVocabularies) var selectedVocabularies: Set<Vocabulary>?
    
    private func copyableVocabularies() -> Array<Vocabulary> {
        if let selectedVocabularies {
            return selectedVocabularies.map { $0.copy() }
        }
        return []
    }
    
    func body(content: Content) -> some View {
        content
            .copyable(copyableVocabularies())
    }
}
