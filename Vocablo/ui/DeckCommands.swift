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
    @FocusedValue(PresentationModel.self) var presentationModel
    
    var body: some Commands {
        CommandGroup(replacing: .newItem) {
            Group {
                AddNewDeckButton()
                    .keyboardShortcut(KeyEquivalent("n"), modifiers: .command.union(.shift))
                    
                Button {
                    presentationModel?.showVocabularyDetailSheet(edit: nil)
                } label: {
                    Label("New vocabulary", systemImage: "plus")
                }
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
