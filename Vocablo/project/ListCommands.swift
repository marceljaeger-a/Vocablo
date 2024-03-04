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
    
    var registeredList: VocabularyList? {
        selectedListValue?.fetchList(with: modelContext)
    }
    
    var body: some Commands {
        CommandGroup(replacing: .newItem) {
            Group {
                NewListButton()
                    .keyboardShortcut(KeyEquivalent("n"), modifiers: .command.union(.shift))
                    
                NewVocabularyButton(list: registeredList)
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
                ResetListButton(title: "Reset list", list: registeredList)
                    .disabled(selectedListValue == nil || selectedListValue == ListSelectingValue.all)
            }
            .modelContext(modelContext)
        }
    }
}
