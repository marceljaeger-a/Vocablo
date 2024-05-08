//
//  ListCommands.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct DeckCommands: Commands {
    let modelContext: ModelContext
    
    @FocusedBinding(\.selectedDeckValue) var selectedDeckValue
    
    var body: some Commands {
        CommandGroup(replacing: .newItem) {
            Group {
                AddNewDeckButton()
                    .keyboardShortcut(KeyEquivalent("n"), modifiers: .command.union(.shift))
                    
                AddNewVocabularyButton(into: selectedDeckValue?.deck)
                    .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
            }
            .modelContext(modelContext)
        }
        
        
        CommandGroup(before: .toolbar) {
            DecksSortingPicker()
            
            VocabularySortingPicker()
            
            Divider()
        }
        
        CommandGroup(after: .pasteboard) {
            Group {
                ResetDeckButton(deck: selectedDeckValue?.deck) {
                    Text("Reset deck")
                }
                .disabled(selectedDeckValue == nil || selectedDeckValue == DeckSelectingValue.all)
                .keyboardShortcut(KeyEquivalent("r"), modifiers: .command.union(.shift))
            }
            .modelContext(modelContext)
        }
    }
}
