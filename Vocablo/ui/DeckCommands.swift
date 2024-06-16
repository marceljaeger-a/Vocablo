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
    @FocusedValue(ModalPresentationModel.self) var presentationModel
    
    var isNewVocabularyButtonDisabled: Bool {
        guard let selectedDeckValue else { return true }
        switch selectedDeckValue {
        case .all:
            return true
        default:
            return false
        }
    }
    
    var body: some Commands {
        CommandGroup(replacing: .newItem) {
            Group {
                Button {
                    presentationModel?.showDeckDetailSheet(edit: nil)
                } label: {
                    Label("New deck", systemImage: "plus")
                }
                .keyboardShortcut(KeyEquivalent("n"), modifiers: .command.union(.shift))
                    
                Button {
                    presentationModel?.showVocabularyDetailSheet(edit: nil)
                } label: {
                    Label("New vocabulary", systemImage: "plus")
                }
                .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
                .disabled(isNewVocabularyButtonDisabled)
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
