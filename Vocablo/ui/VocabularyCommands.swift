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
    
    var unwrappedSelectedVocabularies: Set<Vocabulary> {
        selectedVocabularies ?? []
    }
    
    var body: some Commands {
        CommandGroup(after: .pasteboard) {
            Group {
                ResetVocabulariesButton(vocabularies: unwrappedSelectedVocabularies) {
                    Text("Reset vocabularies")
                }
                .keyboardShortcut(KeyEquivalent("r"), modifiers: .command)
                .disabled(selectedVocabularies?.isEmpty ?? true)
                
//                Divider()
//                
//                SetWordGroupMenu(title: "Set word group", vocabularies: unwrappedSelectedVocabularies)
//                    .disabled(selectedVocabularies?.isEmpty ?? true)
                
                Divider()
                
                SetVocabulariesToLearnButton(unwrappedSelectedVocabularies, to: true) {
                    Text("To learn")
                }
                .keyboardShortcut(KeyEquivalent("l"), modifiers: .command)
                .disabled(selectedVocabularies?.isEmpty ?? true)
                
                SetVocabulariesToLearnButton(unwrappedSelectedVocabularies, to: false) {
                    Text("Not o learn")
                }
                .keyboardShortcut(KeyEquivalent("l"), modifiers: .command.union(.shift))
                .disabled(selectedVocabularies?.isEmpty ?? true)
            }
            .modelContext(modelContext)
        }
    }
}
