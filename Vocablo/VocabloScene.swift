//
//  VocabloScene.swift
//  Vocablo
//
//  Created by Marcel Jäger on 09.12.23.
//

import Foundation
import SwiftUI
import SwiftData
import Combine

struct VocabloScene: Scene {
    @Environment(\.modelContext) var context: ModelContext
    
    @State var selectedListIDs: Set<PersistentIdentifier> = []
    @State var selectedVocabularyIDs: Set<PersistentIdentifier> = []
    @State var showLearningSheet: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView(selectedListIDs: $selectedListIDs, selectedVocabularyIDs: $selectedVocabularyIDs, showLearningSheet: $showLearningSheet)
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Add list") {
                    context.addList("New list")
                }
                .keyboardShortcut(KeyEquivalent("n"), modifiers: .command.union(.option))
                
                Button("Add vocabulary") {
                    guard let firstSelectedList: VocabularyList =  context.fetch(ids: selectedListIDs).first else { return }
                    firstSelectedList.addNewVocabulary()
                }
                .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
                .disabled(selectedListIDs.isEmpty)
            }
            CommandGroup(after: .pasteboard) {
                Divider()
                
                CommandWordGroupPicker(vocabularies: context.fetch(ids: selectedVocabularyIDs))
                    .disabled(selectedVocabularyIDs.isEmpty)
                
                Divider()
                
                if let firstList: VocabularyList = context.fetch(ids: selectedListIDs).first{
                    @Bindable var bindedList = firstList
                    Picker("List sort by", selection: $bindedList.sorting) {
                        VocabularyList.VocabularySorting.pickerContent
                    }
                    .disabled(selectedListIDs.count != 1)
                }else {
                    Menu("List sort by") {
                        
                    }
                    .disabled(selectedListIDs.count != 1)
                }
                    
                
            }
            
            CommandMenu("Learning") {
                Button("Learn") {
                    showLearningSheet = true
                }
                .disabled(selectedListIDs.count != 1)
                
                Divider()
                
                Button("To learn"){
                    context.toLearn(for: context.fetch(ids: selectedVocabularyIDs))
                }
                .keyboardShortcut(KeyEquivalent("l"), modifiers: .command)
                .disabled(selectedVocabularyIDs.isEmpty)
                
                Button("Not to learn"){
                    context.notToLearn(for: context.fetch(ids: selectedVocabularyIDs))
                }
                .keyboardShortcut(KeyEquivalent("l"), modifiers: .command.union(.shift))
                .disabled(selectedVocabularyIDs.isEmpty)
                
                Divider()
                
                Button("Reset lists") {
                    context.resetList(context.fetch(ids: selectedListIDs))
                }
                .disabled(selectedListIDs.isEmpty)
                
                Button("Reset vocabularies") {
                    context.resetVocabularies(context.fetch(ids: selectedVocabularyIDs))
                }
                .disabled(selectedVocabularyIDs.isEmpty)
            }
        }
    }
}
