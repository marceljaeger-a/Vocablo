//
//  VocabularyCommands.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct VocabularyCommands: Commands {
    let modelContext: ModelContext
    
    @FocusedBinding(\.selectedVocabularies) var selectedVocabularies
    
    var unwrappedSelectedVocabularies: Set<PersistentIdentifier> {
        selectedVocabularies ?? []
    }
    
    var body: some Commands {
        CommandGroup(after: .pasteboard) {
            Group {
                ResetVocabulariesButton(title: "Reset vocabularies", unwrappedSelectedVocabularies)
                    .keyboardShortcut(KeyEquivalent("r"), modifiers: .command)
                    .disabled(selectedVocabularies?.isEmpty ?? true)
                
                Divider()
                
                SetWordGroupMenu(title: "Set word goup", of: selectedVocabularies ?? [])
                    .disabled(selectedVocabularies?.isEmpty ?? true)
                
                Divider()
                
                SetVocabularyToLearnButton(unwrappedSelectedVocabularies, to: true, title: "To learn")
                    .keyboardShortcut(KeyEquivalent("l"), modifiers: .command)
                    .disabled(selectedVocabularies?.isEmpty ?? true)
                
                SetVocabularyToLearnButton(unwrappedSelectedVocabularies, to: false, title: "Not to learn")
                    .keyboardShortcut(KeyEquivalent("l"), modifiers: .command.union(.shift))
                    .disabled(selectedVocabularies?.isEmpty ?? true)
            }
            .modelContext(modelContext)
        }
    }
}
