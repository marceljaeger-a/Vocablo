//
//  ListCommands.swift
//  Vocablo
//
//  Created by Marcel Jäger on 01.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct ListCommands: Commands {
    let modelContext: ModelContext
    
    @FocusedBinding(\.selectedList) var selectedListValue
    
    var body: some Commands {
        CommandGroup(replacing: .newItem) {
            Group {
                AddNewListButton()
                    .keyboardShortcut(KeyEquivalent("n"), modifiers: .command.union(.shift))
                    
                AddNewVocabularyButton(into: selectedListValue?.list)
                    .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
            }
            .modelContext(modelContext)
        }
        
        
        CommandGroup(before: .toolbar) {
            
            //Sorting of list
            Text("Sort list by")
            
            Divider()
        }
        
        CommandGroup(after: .pasteboard) {
            Group {
                ResetListButton(list: selectedListValue?.list) {
                    Text("Reset list")
                }
                .disabled(selectedListValue == nil || selectedListValue == ListSelectingValue.all)
            }
            .modelContext(modelContext)
        }
    }
}
